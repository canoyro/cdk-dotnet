param(
    [string]$IisWebRoot = $env:IIS_WEB_ROOT
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($IisWebRoot)) {
    throw "IIS_WEB_ROOT is required. Example: C:\inetpub\wwwroot"
}

$packageRoot = Split-Path -Parent $PSScriptRoot
$siteSource = Join-Path $packageRoot "website-dist"

if (-not (Test-Path -LiteralPath $siteSource)) {
    throw "website-dist was not found in the extracted package at: $siteSource"
}

if (-not (Test-Path -LiteralPath $IisWebRoot)) {
    New-Item -ItemType Directory -Path $IisWebRoot -Force | Out-Null
}

Get-ChildItem -LiteralPath $IisWebRoot -Force | Remove-Item -Recurse -Force
Copy-Item -Path (Join-Path $siteSource "*") -Destination $IisWebRoot -Recurse -Force

Write-Host "Copied website-dist to $IisWebRoot"
