<#
.SYNOPSIS
    Creates a new blog post (or draft) with the front matter already filled in.

.EXAMPLE
    .\new-post.ps1 "What I Learned From Reviewing 40 Papers"

.EXAMPLE
    .\new-post.ps1 "Field Notes From Nairobi" -Tags research,fieldwork -Open

.EXAMPLE
    .\new-post.ps1 "Half-Formed Idea" -Draft
    Writes to _drafts\ instead. Drafts are not published until you move the
    file into _posts\ with a date prefix.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title,

    # e.g. -Tags research,teaching
    [string[]]$Tags = @(),

    # Publication date as yyyy-MM-dd. Defaults to today.
    [string]$Date,

    # Write to _drafts\ instead of _posts\.
    [switch]$Draft,

    # Open the new file in your default editor.
    [switch]$Open
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# Resolve the timestamp -----------------------------------------------------
if ($Date) {
    try {
        $stamp = [datetime]::ParseExact($Date, 'yyyy-MM-dd', $null)
    } catch {
        throw "-Date must look like 2026-08-06 (got '$Date')."
    }
} else {
    $stamp = Get-Date
}

# Jekyll wants the UTC offset as -0500, not -05:00.
$offset = (Get-Date).ToString('zzz').Replace(':', '')
$dateLine = '{0} {1}' -f $stamp.ToString('yyyy-MM-dd HH:mm:ss'), $offset

# Slugify the title: lowercase, alphanumerics and dashes only ---------------
$slug = $Title.ToLowerInvariant()
$slug = $slug -replace "['‘’]", ''      # drop apostrophes outright
$slug = $slug -replace '[^a-z0-9]+', '-'
$slug = $slug.Trim('-')

if (-not $slug) { throw "Could not build a filename from the title '$Title'." }

# Decide where it goes ------------------------------------------------------
if ($Draft) {
    $dir = Join-Path $root '_drafts'
    $file = Join-Path $dir "$slug.md"
} else {
    $dir = Join-Path $root '_posts'
    $file = Join-Path $dir ('{0}-{1}.md' -f $stamp.ToString('yyyy-MM-dd'), $slug)
}

if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
}

if (Test-Path $file) {
    throw "$file already exists. Pick a different title or date."
}

# Build the front matter ----------------------------------------------------
# Titles are quoted so colons in them do not break the YAML.
$escapedTitle = $Title.Replace('"', '\"')
$tagLine = if ($Tags.Count -gt 0) { '[' + ($Tags -join ', ') + ']' } else { '[]' }

$content = @"
---
title: "$escapedTitle"
date: $dateLine
tags: $tagLine
# subtitle: Optional line under the title
# image: /img/your-banner.jpg
---

The first paragraph becomes the excerpt shown on the blog index. Write it so it
stands on its own.

The rest of the post goes here.
"@

# UTF-8 without BOM -- a BOM at the top of the file stops Jekyll from seeing
# the front matter, and the post silently fails to build.
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($file, $content, $utf8NoBom)

Write-Host "Created $file" -ForegroundColor Green
Write-Host ""
Write-Host "Next:" -ForegroundColor Cyan
Write-Host "  1. Write the post."
if ($Draft) {
    Write-Host "  2. Move it into _posts\ as YYYY-MM-DD-$slug.md when ready."
    Write-Host "  3. git add . ; git commit -m ""Add post: $Title"" ; git push"
} else {
    Write-Host "  2. git add . ; git commit -m ""Add post: $Title"" ; git push"
    Write-Host "  3. It goes live in a minute or two."
}

if ($Open) { Invoke-Item $file }
