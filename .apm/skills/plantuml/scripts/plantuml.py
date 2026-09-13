#!/usr/bin/env python

"""
Render PlantUML source files into png/svg/txt via PlantUML server.

This script encodes PlantUML text using the PlantUML server text-encoding
algorithm, then requests rendered output from the configured server.
"""

from __future__ import annotations

import argparse
import glob
import urllib.error
import urllib.request
import zlib
from dataclasses import dataclass
from pathlib import Path


class PlantUmlError(Exception):
    """Base exception for PlantUML rendering errors."""


class PlantUmlInputError(PlantUmlError):
    """Raised when input path expansion fails or yields no files."""


class PlantUmlHttpError(PlantUmlError):
    """Raised when the PlantUML server request fails."""


@dataclass(frozen=True)
class RenderResult:
    """
    Represents one render operation result.

    Attributes:
        source: Source PlantUML file path.
        output: Generated output file path.
        format: Output format, such as ``png``, ``svg``, or ``txt``.
    """

    source: Path
    output: Path
    format: str


def deflate_and_encode(plantuml_text: str) -> str:
    """
    Compress and encode text for the PlantUML server.

    Args:
        plantuml_text: Raw PlantUML text content.

    Returns:
        The encoded text segment used in PlantUML server URLs.
    """
    zlibbed = zlib.compress(plantuml_text.encode("utf-8"))
    compressed = zlibbed[2:-4]

    chunks: list[str] = []
    for offset in range(0, len(compressed), 3):
        byte1 = compressed[offset]
        byte2 = compressed[offset + 1] if offset + 1 < len(compressed) else 0
        byte3 = compressed[offset + 2] if offset + 2 < len(compressed) else 0
        chunks.append(_append_3bytes(byte1, byte2, byte3))

    return "".join(chunks)


def _append_3bytes(byte1: int, byte2: int, byte3: int) -> str:
    """
    Encode 3 bytes into 4 PlantUML base64-like characters.

    Args:
        byte1: First byte.
        byte2: Second byte.
        byte3: Third byte.

    Returns:
        Encoded 4-character chunk.
    """
    char1 = byte1 >> 2
    char2 = ((byte1 & 0x3) << 4) | (byte2 >> 4)
    char3 = ((byte2 & 0xF) << 2) | (byte3 >> 6)
    char4 = byte3 & 0x3F
    return (
        _encode_6bit(char1 & 0x3F)
        + _encode_6bit(char2 & 0x3F)
        + _encode_6bit(char3 & 0x3F)
        + _encode_6bit(char4 & 0x3F)
    )


def _encode_6bit(value: int) -> str:
    """
    Map a 6-bit integer to PlantUML alphabet.

    Args:
        value: 6-bit integer in the range ``0`` to ``63``.

    Returns:
        One encoded character.
    """
    if value < 10:
        return chr(48 + value)

    value -= 10
    if value < 26:
        return chr(65 + value)

    value -= 26
    if value < 26:
        return chr(97 + value)

    value -= 26
    if value == 0:
        return "-"
    return "_"


def build_render_url(server_url: str, output_format: str, encoded: str) -> str:
    """
    Build a render URL for the PlantUML server.

    Args:
        server_url: Base server URL.
        output_format: Target format (`png`, `svg`, or `txt`).
        encoded: Encoded PlantUML payload.

    Returns:
        Fully-qualified render URL.
    """
    base = server_url.rstrip("/")
    suffix = f"/{output_format}"
    if base.lower().endswith(suffix):
        return f"{base}/{encoded}"
    return f"{base}/{output_format}/{encoded}"


def expand_inputs(patterns: list[str]) -> list[Path]:
    """
    Expand wildcard input patterns into unique existing files.

    Args:
        patterns: Input path patterns. Wildcards are supported.

    Returns:
        Sorted unique file paths.

    Raises:
        PlantUmlInputError: If no files match the provided patterns.
    """
    matches: set[Path] = set()
    for pattern in patterns:
        for matched in glob.glob(pattern, recursive=True):
            path = Path(matched)
            if path.is_file():
                matches.add(path.resolve())

    if not matches:
        joined = ", ".join(patterns)
        raise PlantUmlInputError(
            f"No files matched input pattern(s): {joined}")

    return sorted(matches, key=lambda p: str(p).lower())


def fetch_rendered_content(
    server_url: str,
    output_format: str,
    plantuml_text: str,
) -> bytes:
    """
    Request rendered content from PlantUML server.

    Args:
        server_url: Base server URL.
        output_format: Output format (`png`, `svg`, or `txt`).
        plantuml_text: PlantUML source content.

    Returns:
        Rendered payload as bytes.

    Raises:
        PlantUmlHttpError: If the server request fails.
    """
    encoded = deflate_and_encode(plantuml_text)
    render_url = build_render_url(server_url, output_format, encoded)

    try:
        with urllib.request.urlopen(render_url, timeout=30.0) as response:
            return response.read()
    except urllib.error.URLError as exc:
        raise PlantUmlHttpError(f"PlantUML request failed: {exc}") from exc


def render_file(
    source_file: Path,
    output_dir: Path,
    server_url: str,
    output_format: str,
) -> RenderResult:
    """
    Render one PlantUML file and write the result to disk.

    Args:
        source_file: Input PlantUML file path.
        output_dir: Output directory path.
        server_url: Base PlantUML server URL.
        output_format: Output format (`png`, `svg`, or `txt`).

    Returns:
        A render result descriptor.
    """
    output_dir.mkdir(parents=True, exist_ok=True)
    source_text = source_file.read_text(encoding="utf-8")
    payload = fetch_rendered_content(server_url, output_format, source_text)

    output_file = output_dir / f"{source_file.stem}.{output_format}"
    if output_format == "txt":
        output_file.write_text(payload.decode("utf-8"), encoding="utf-8")
    else:
        output_file.write_bytes(payload)

    return RenderResult(source=source_file, output=output_file, format=output_format)


def create_parser() -> argparse.ArgumentParser:
    """
    Create and configure the command-line parser.

    Returns:
        A configured argument parser.
    """
    parser = argparse.ArgumentParser(
        description="Render PlantUML text files via PlantUML server.",
    )
    parser.add_argument(
        "-u",
        "--url",
        default="http://localhost:8080",
        help="PlantUML server URL (default: http://localhost:8080).",
    )
    parser.add_argument(
        "-i",
        "--input",
        nargs="+",
        required=True,
        help="Input PlantUML text file path(s). Wildcards are supported.",
    )
    parser.add_argument(
        "-o",
        "--output",
        default=".",
        help="Output directory (default: current directory).",
    )
    parser.add_argument(
        "-f",
        "--format",
        choices=("png", "svg", "txt"),
        default="png",
        help="Output format (default: png).",
    )
    return parser


def main() -> int:
    """
    Run CLI entrypoint.

    Returns:
        Process exit code.
    """
    args = create_parser().parse_args()

    try:
        files = expand_inputs(args.input)
    except PlantUmlInputError as exc:
        print(f"[ERROR] {exc}")
        return 2

    output_dir = Path(args.output).resolve()

    for file_path in files:
        try:
            result = render_file(
                source_file=file_path,
                output_dir=output_dir,
                server_url=args.url,
                output_format=args.format,
            )
            print(f"[OK] {result.source} -> {result.output}")
        except (PlantUmlError, UnicodeDecodeError, OSError) as exc:
            print(f"[ERROR] {file_path}: {exc}")
            return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
