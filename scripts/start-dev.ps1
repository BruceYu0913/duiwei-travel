$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $repoRoot
$composer = Join-Path $workspaceRoot '.runtime\bin\composer.cmd'

& (Join-Path $PSScriptRoot 'start-mysql.ps1')

if (-not (Test-Path -LiteralPath $composer)) {
    throw "Composer wrapper not found: $composer"
}

$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

Set-Location $repoRoot
& $composer run dev
