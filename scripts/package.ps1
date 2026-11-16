$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$addon = Join-Path $root 'AggeStealthBar'
$toc = Get-Content -LiteralPath (Join-Path $addon 'AggeStealthBar.toc') -Raw
if ($toc -notmatch '(?m)^## Version: ([0-9A-Za-z.-]+)\r?$') { throw 'Invalid version.' }
$version = $Matches[1]
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$destination = Join-Path $dist "AggeStealthBar-$version.zip"
if (Test-Path -LiteralPath $destination) { Remove-Item -LiteralPath $destination }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::Open($destination, 'Create')
try {
    foreach ($file in Get-ChildItem -LiteralPath $addon -File -Recurse) {
        $relative = [System.IO.Path]::GetRelativePath($root, $file.FullName).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $relative) | Out-Null
    }
    foreach ($file in @('LICENSE', 'README.md', 'CHANGELOG.md')) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, (Join-Path $root $file), "AggeStealthBar/$file") | Out-Null
    }
} finally { $archive.Dispose() }
Write-Output $destination
