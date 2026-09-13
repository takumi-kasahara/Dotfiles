---
name: plantuml
description: "Generate PlantUML images from text files using a local or remote PlantUML server. Use when converting *.puml/*.plantuml files to png/svg/txt via Python, especially with wildcard input patterns and Docker-hosted PlantUML at http://localhost:8080."
argument-hint: "Describe the input pattern(s), output directory, format, and PlantUML server URL."
user-invocable: true
---

# PlantUML Image Generation Skill

Create images (or text output) from PlantUML source files by calling a PlantUML server from Python.

## When to Use This Skill

- You want to render `*.puml` or `*.plantuml` files to images.
- Your PlantUML server runs locally (for example Docker at `http://localhost:8080`).
- You need wildcard input like `docs/**/*.puml`.
- You want reproducible CLI execution in a Python script.

## Prerequisites

- Python 3
- A running PlantUML server
  - Example: `http://localhost:8080`

## Step-by-Step Workflow

1. Confirm the PlantUML server is reachable.
2. Run the script with Python.
3. Validate output files in the target directory.

```bash
python ./.agents/skills/plantuml/scripts/plantuml.py -i "docs/**/*.puml" -o "./out" -f png
```

Use a custom server URL when needed:

```bash
python ./.agents/skills/plantuml/scripts/plantuml.py -u "http://localhost:8080" -i "./diagrams/*.puml" -o "./generated" -f svg
```

## CLI Arguments

| Argument         | Required | Default                 | Description                                    |
| ---------------- | -------- | ----------------------- | ---------------------------------------------- |
| `-u`, `--url`    | No       | `http://localhost:8080` | PlantUML server URL                            |
| `-i`, `--input`  | Yes      | -                       | PlantUML text file path(s), wildcard supported |
| `-o`, `--output` | No       | current directory       | Output directory                               |
| `-f`, `--format` | No       | `png`                   | Output format: `png`, `svg`, `txt`             |

## Gotchas

- **Use wildcard patterns in quotes** to prevent shell-side expansion differences across environments.
- **The server URL can be host-only** (for example `http://localhost:8080`); the script appends the format path (`/png/`, `/svg/`, `/txt/`).
- **Duplicate file stems can overwrite outputs** when multiple input directories contain files with the same base filename.

## Troubleshooting

| Issue                    | Solution                                                                                  |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| `No files matched`       | Check the wildcard pattern and current working directory.                                 |
| HTTP 404/500 from server | Verify server URL and that the format endpoint is supported.                              |
| Timeout                  | Ensure Docker container is running and reachable from the current host network namespace. |

## References

- Script: [scripts/plantuml.py](./scripts/plantuml.py)
- PlantUML server docs: <https://plantuml.com/en/server>
- PlantUML text encoding docs: <https://plantuml.com/en/text-encoding>
