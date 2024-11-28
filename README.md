# LaTeX-in-Terminal

Convert LaTeX expressions to PNG images directly from the terminal and copy them to the clipboard. Designed for macOS.

## Prerequisites

Ensure the following tools are installed:

- `curl`
- `jq`
- `pbcopy` (macOS)
- `osascript` (macOS)

## Usage
```
Usage: ./run.sh [-v] [-r resolution] "LaTeX expression"
```
Or use the oneliner without cloning
```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/detrin/latex-in-terminal/refs/heads/main/run.sh | sh -s -- -r 200 "E=mc^2"
```

## Notes
- Only runs on macOS due to clipboard operations.
- Automatically cleans up temporary files post-process.