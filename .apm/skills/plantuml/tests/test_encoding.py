#!/usr/bin/env python

"""
Verify PlantUML encoding output against a golden value.

This test script imports `plantuml.py` from the same directory and validates
that a known diagram text is encoded to the expected PlantUML string.
"""

from __future__ import annotations

import importlib.util
import pathlib
import sys
import unittest


class TestPlantUmlEncoding(unittest.TestCase):
    """Tests for `deflate_and_encode` golden output."""

    def test_sequence_diagram_encoding(self) -> None:
        """
        Validate encoding for a known sequence diagram.

        The following PlantUML text must encode to the expected golden value:

        .. code-block:: text

            Bob -> Alice : hello
        """
        module = _load_plantuml_module()

        diagram_text = "Bob -> Alice : hello"
        expected = "SyfFKj2rKt3CoKnELR1Io4ZDoSa70000"

        actual = module.deflate_and_encode(diagram_text)
        self.assertEqual(actual, expected)


def _load_plantuml_module():
    """
    Load `plantuml.py` from the current script directory.

    Returns:
        Imported `plantuml.py` module object.

    Raises:
        RuntimeError: If the module cannot be loaded.
    """
    script_dir = pathlib.Path(__file__).resolve().parent.parent
    target_script = script_dir / "scripts" / "plantuml.py"

    spec = importlib.util.spec_from_file_location(
        "plantuml_mod", target_script)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Failed to load module spec from: {target_script}")

    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main() -> int:
    """
    Run tests and return process exit code.

    Returns:
        Exit code where `0` means success.
    """
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(
        TestPlantUmlEncoding)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    return 0 if result.wasSuccessful() else 1


if __name__ == "__main__":
    raise SystemExit(main())
