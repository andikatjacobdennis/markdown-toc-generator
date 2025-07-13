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
   .\Generate-MarkdownTOC.ps1 -InputFile input.txt -OutputFile toc.md
````

> 📁 This will read from `input.txt` and generate a Markdown-compatible TOC in `toc.md`.

## Example Input (`input.txt`)

```
1. Introduction to C#
1.1. What is C#?
1.2. History and Evolution
...
```

## Example Output (`toc.md`)

```markdown
- [1. Introduction to C#](#1-introduction-to-c)
  - [1.1. What is C#?](#11-what-is-c)
  - [1.2. History and Evolution](#12-history-and-evolution)
```

## Files

| File                       | Description                                |
| -------------------------- | ------------------------------------------ |
| `Generate-MarkdownTOC.ps1` | PowerShell script to generate Markdown TOC |
| `input.txt`                | Sample headings for testing                |
| `toc.md`                   | Example generated output (optional)        |

## License

MIT
