[CmdletBinding()]
param(
    [switch] $SkipDatabaseCheck,
    [switch] $CheckOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$pathParts = @($machinePath, $userPath, $env:Path) |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
$env:Path = [string]::Join(';', $pathParts)

function Resolve-RequiredCommand {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $InstallHint
    )

    $command = Get-Command $Name -ErrorAction SilentlyContinue

    if (-not $command) {
        throw "$Name was not found in PATH. $InstallHint"
    }

    return $command.Source
}

$php = Resolve-RequiredCommand -Name 'php' -InstallHint 'Install PHP 8.3 or later, then open a new PowerShell window.'
$composer = Resolve-RequiredCommand -Name 'composer' -InstallHint 'Install Composer 2, then open a new PowerShell window.'
$node = Resolve-RequiredCommand -Name 'node' -InstallHint 'Install Node.js, then open a new PowerShell window.'
$npx = Resolve-RequiredCommand -Name 'npx' -InstallHint 'Install Node.js with npm/npx, then open a new PowerShell window.'
$pnpm = Resolve-RequiredCommand -Name 'pnpm' -InstallHint 'Install pnpm, then open a new PowerShell window.'

$envFile = Join-Path $repoRoot '.env'
$autoloadFile = Join-Path $repoRoot 'vendor\autoload.php'
$nodeModules = Join-Path $repoRoot 'node_modules'

if (-not (Test-Path -LiteralPath $envFile)) {
    throw 'Missing .env. Run: Copy-Item .env.example .env; php artisan key:generate'
}

if (-not (Test-Path -LiteralPath $autoloadFile)) {
    throw 'Composer dependencies are missing. Run: composer install'
}

if (-not (Test-Path -LiteralPath $nodeModules)) {
    throw 'Node dependencies are missing. Run: pnpm install --frozen-lockfile'
}

if (-not $SkipDatabaseCheck) {
    & (Join-Path $PSScriptRoot 'start-mysql.ps1') -CheckOnly:$CheckOnly
}

Write-Host "Project root: $repoRoot"
Write-Host "PHP: $php"
Write-Host "Composer: $composer"
Write-Host "Node.js: $node"
Write-Host "npx: $npx"
Write-Host "pnpm: $pnpm"

if ($CheckOnly) {
    Write-Host 'Development environment check passed.'
    exit 0
}

Push-Location -LiteralPath $repoRoot

try {
    & $composer run dev

    if ($LASTEXITCODE -ne 0) {
        throw "The development process exited with code $LASTEXITCODE."
    }
} finally {
    Pop-Location
}
