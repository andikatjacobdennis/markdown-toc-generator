# Markdown TOC Generator (PowerShell)

A lightweight PowerShell script to generate a Table of Contents for Markdown-style documents and optionally create structured Markdown files from a topic list.

## Features

- Parses hierarchical topics from a text input
- Outputs a clickable GitHub-flavored TOC (`index.md`)
- Automatically creates organized folders and Markdown files under `docs/`
- Generates a build log (`logger.ps1.log`)
- Easy to run via PowerShell — no dependencies

## How to Run

1. Open **PowerShell**
2. Navigate to the folder containing the script and input file
3. Run the script:

   ```powershell
   .\Generate-MarkdownTOC.ps1
   ```

> This will read `input.txt`, generate a structured TOC, create corresponding `.md` content under `docs/`, and log the process to `logger.ps1.log`.

## Output Structure

Example output after running the script:

```
markdown-toc-generator/
│
├── Generate-MarkdownTOC.ps1        # PowerShell script
├── input.txt                       # Input topic list
├── README.md                       # This file
├── LICENSE                         # License info
├── logger.ps1.log                  # Log file with processing info
│
└───docs/                           # Generated markdown content
    ├── index.md                    # Table of Contents
    ├── 001_Introduction-to-C-Sharp/
    │   ├── index.md
    │   ├── 001.001.What-is-C-Sharp.md
    │   ├── ...
    │
    └── 002_C-Sharp-Language-Basics/
        ├── index.md
        ├── 002.001.Syntax-and-Structure.md
        ├── ...
```

## Files

| File/Folder                | Description                                                |
| -------------------------- | ---------------------------------------------------------- |
| `Generate-MarkdownTOC.ps1` | The main PowerShell script                                 |
| `input.txt`                | Input file with topic list (like C# course outline)        |
| `logger.ps1.log`           | Log file generated during script execution                 |
| `docs/`                    | Folder with generated `index.md` and structured subfolders |
| `README.md`                | This documentation                                         |
| `LICENSE`                  | MIT License                                                |

## License

Open-source under [MIT License](LICENSE)
