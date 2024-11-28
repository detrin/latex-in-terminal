# LaTeX-in-Terminal

Convert LaTeX expressions to PNG images directly from the terminal and copy them to the clipboard. Designed for macOS.

## Prerequisites

Ensure the following tools are installed:

- `curl`
- `jq`
- `pbcopy` (macOS)
- `osascript` (macOS)

## Installation

Make the script executable:

```bash
./run.sh -v "E=mc^2"
```

## Notes
- Only runs on macOS due to clipboard operations.
- Automatically cleans up temporary files post-process.