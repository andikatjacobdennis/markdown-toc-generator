# Markdown TOC Generator (PowerShell)

A lightweight PowerShell script to generate a Table of Contents for Markdown-style documents.

## Features

- Supports nested headings (e.g., `#`, `##`, `###`)
- Outputs clickable anchor links (GitHub-flavored)
- Easy CLI usage
- No dependencies

## How to Run

1. Open **PowerShell**
2. Navigate to the folder containing the script and input file
3. Run:

   ```powershell
   .\Generate-MarkdownTOC.ps1
   ```

> This will read from `input.txt` and generate a Markdown-compatible TOC in a new file.

## Files

| File                       | Description                                |
| -------------------------- | ------------------------------------------ |
| `Generate-MarkdownTOC.ps1` | PowerShell script to generate Markdown TOC |
| `input.txt`                | Sample headings for testing                |

## License

MIT
