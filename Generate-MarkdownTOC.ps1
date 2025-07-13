# Configuration
$inputFile = "input.txt"
$rootFolder = "docs"
$indexFile = "index.md"
$logFile = "logger.ps1.log"

function Sanitize-Name($name) {
    $name = $name -replace '#', ' Sharp'             # Replace # with 'Sharp'
    $name = $name -replace '[\/<>]', '_'            # Replace / < > with _
    $name = $name -replace '[^a-zA-Z0-9\-\.\[\]\(\) _]', ''  # Allow only safe characters
    return $name -replace '\s+', '-'                # Replace spaces with hyphens
}

# Pad number segments
function Pad-Parts($parts) {
    return $parts | ForEach-Object { "{0:D3}" -f [int]$_ }
}

# Parse input line
function Parse-Line($line) {
    if ($line -match "^((\d+\.)+)\s*(.+)$") {
        $parts = $matches[1] -split '\.' | Where-Object { $_ -ne '' }
        $title = $matches[3].Trim()
        return ,@($parts, $title)
    }
    return $null
}

# Build relative path for index
function Make-Relative($absPath, $root) {
    $rootFullPath = (Resolve-Path $root).Path
    $absFullPath = (Resolve-Path $absPath).Path
    return $absFullPath.Substring($rootFullPath.Length).TrimStart('\') -replace '\\', '/'
}

# Logging utilities
function Log-Info($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [INFO] $msg" | Out-File -LiteralPath $logFile -Append -Encoding UTF8
}
function Log-Warn($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [WARN] $msg" | Out-File -LiteralPath $logFile -Append -Encoding UTF8
}
function Log-Error($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [ERROR] $msg" | Out-File -LiteralPath $logFile -Append -Encoding UTF8
}

# Main processing
try {
    Remove-Item $logFile -ErrorAction SilentlyContinue
    Log-Info "Started processing"

    if (-not (Test-Path $inputFile)) {
        throw "Input file not found: $inputFile"
    }

    New-Item -Path $rootFolder -ItemType Directory -Force | Out-Null
    $indexContent = "# Documentation Index`n`n"

    # ✅ Read input as UTF-8 to avoid garbled characters
    $lines = Get-Content $inputFile -Encoding UTF8

    $entries = @()
    $hasChildren = @{}

    # Parse and collect entries
    foreach ($line in $lines) {
        $line = $line.Trim()

        # Optional: normalize smart dashes and quotes
        $line = $line -replace '[\u2013\u2014]', '-'  # en/em dash → hyphen
        $line = $line -replace '[\u2018\u2019]', "'" # single quotes
        $line = $line -replace '[\u201C\u201D]', '"' # double quotes

        $parsed = Parse-Line $line
        if ($parsed) {
            $parts = $parsed[0]
            $title = $parsed[1]
            $entries += [PSCustomObject]@{
                RawParts = $parts
                Title    = $title
                Padded   = Pad-Parts $parts
                Key      = ($parts -join '.')
                Depth    = $parts.Count
            }
            if ($parts.Count -gt 1) {
                $parent = ($parts[0..($parts.Count - 2)] -join '.')
                $hasChildren[$parent] = $true
            }
        }
    }

    # Build file/folder structure
    $pathMap = @{}
    foreach ($entry in $entries) {
        try {
            $title = $entry.Title
            $padded = $entry.Padded
            $depth = $entry.Depth
            $numbering = ($padded -join '.')
            $safeName = Sanitize-Name $title
            $currentKey = $entry.Key
            $parentKey = if ($depth -gt 1) { ($entry.RawParts[0..($depth - 2)] -join '.') } else { '' }
            $parentPath = if ($depth -eq 1) { $rootFolder } else { $pathMap[$parentKey] }

            if (-not $parentPath) {
                Log-Warn "Skipping $numbering $title due to missing parent"
                continue
            }

            $indent = '  ' * ($depth - 1)

            if ($hasChildren.ContainsKey($currentKey)) {
                # Create folder
                $folderName = "$numbering" + "_$safeName"
                $folderPath = Join-Path $parentPath $folderName
                New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
                $pathMap[$currentKey] = $folderPath

                # Create index.md in folder
                $folderIndexPath = Join-Path $folderPath "index.md"
                "# $numbering $title`n`n## Section Overview`nYour content goes here" | Out-File -LiteralPath $folderIndexPath -Force -Encoding UTF8

                # Link to folder's index.md
                $relative = Make-Relative $folderIndexPath $rootFolder
                $indexContent += "$indent- [$numbering $title]($relative)`n"
                Log-Info "Created folder: $folderPath and index.md"
            } else {
                # Create file
                $fileName = "$numbering.$safeName.md"
                $filePath = Join-Path $parentPath $fileName
                "# $numbering $title`n`n## Content`nYour content goes here" | Out-File -LiteralPath $filePath -Force -Encoding UTF8
                $relative = Make-Relative $filePath $rootFolder
                $indexContent += "$indent- [$numbering $title]($relative)`n"
                Log-Info "Created file: $filePath"
            }
        } catch {
            Log-Error "Failed processing $($entry.Key): $_"
        }
    }

    # Write index.md
    if (-not [string]::IsNullOrWhiteSpace($indexContent)) {
        $indexPath = Join-Path $rootFolder $indexFile
        $indexContent | Out-File -LiteralPath $indexPath -Force -Encoding UTF8
        Log-Info "Index file created: $indexPath"
    } else {
        Log-Warn "Index content was empty. Skipping index file creation."
    }

    Write-Host "Generation complete. Log: $logFile"

} catch {
    Log-Error "Fatal error: $_"
    Write-Error "Script failed. Check log: $logFile"
}
