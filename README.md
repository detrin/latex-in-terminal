# LaTeX-in-Terminal

Convert LaTeX expressions to PNG images directly from the terminal and copy them to the clipboard. Designed for macOS. It uses the backend of https://www.sciweavers.org/process_form_tex2img.

## Prerequisites

Ensure the following tools are installed:

- `curl`
- `jq`
- `pbcopy` (macOS)
- `osascript` (macOS)

## Usage
```
Usage: ./run.sh [-v] [-s font_size] "LaTeX expression"
```
Or use the oneliner without cloning
```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/detrin/latex-in-terminal/refs/heads/main/run.sh | sh -s -- -s 18 'E=mc^2'
```
Be sure you use only single quotes for provided LaTeX expression.

## Notes
- Only runs on macOS due to clipboard operations.
- Automatically cleans up temporary files post-process.