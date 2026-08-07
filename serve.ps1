<#
.SYNOPSIS
    Previews the site locally at http://localhost:4000, drafts included.

.DESCRIPTION
    Builds to a temp folder rather than .\_site on purpose. This repo lives in
    a Box-synced directory, and a build writes ~1,400 files / 13 MB (mostly
    vendor/). Left in _site, Box tries to sync all of it on every rebuild,
    which made a full build take ~165 seconds. Out of the Box tree it is far
    faster and Box stays quiet.

    Ctrl+C to stop.

.EXAMPLE
    .\serve.ps1

.EXAMPLE
    .\serve.ps1 -NoDrafts     # see only what is actually published
#>
[CmdletBinding()]
param(
    # Hide _drafts, showing exactly what the live site would show.
    [switch]$NoDrafts,

    # Disable incremental builds. Slower, but picks up layout/include edits
    # reliably.
    [switch]$Full,

    # Fall back to polling if edits are not being picked up.
    [switch]$ForcePolling
)

$ErrorActionPreference = 'Stop'

# This session may predate the Ruby install, so take PATH from the registry.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command bundle -ErrorAction SilentlyContinue)) {
    throw "Ruby/bundler not found. Open a new terminal, or reinstall with: winget install RubyInstallerTeam.RubyWithDevKit.3.3"
}

$dest = Join-Path $env:TEMP 'jekyll-dianajue'

# --incremental matters a lot here. Without it, every save re-copies all ~1,400
# vendor/ files and a rebuild takes ~90s. With it, only changed pages are
# regenerated. The tradeoff: edits to _layouts/ or _includes/ are sometimes
# missed, so restart the server (or pass -Full) after touching those.
$jekyllArgs = @('exec', 'jekyll', 'serve', '--destination', $dest, '--livereload')
if (-not $NoDrafts)  { $jekyllArgs += '--drafts' }
if (-not $Full)      { $jekyllArgs += '--incremental' }
if ($ForcePolling)   { $jekyllArgs += '--force_polling' }

Write-Host ""
Write-Host "  Serving http://localhost:4000" -ForegroundColor Green
Write-Host "  Drafts: $(if ($NoDrafts) { 'hidden' } else { 'shown' })" -ForegroundColor Cyan
Write-Host "  Output: $dest (outside Box, kept out of the repo)" -ForegroundColor DarkGray
Write-Host "  Ctrl+C to stop. Edits rebuild automatically; _config.yml needs a restart."
Write-Host ""

& bundle @jekyllArgs
