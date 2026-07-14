$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$managedPidFile = Join-Path (Join-Path (Join-Path $repoRoot '.runtime') 'mysql') 'managed-process.pid'

if (-not (Test-Path -LiteralPath $managedPidFile)) {
    Write-Host 'No project-managed MySQL process is recorded. The system MySQL service will not be stopped.'
    exit 0
}

$managedPidText = (Get-Content -Raw -LiteralPath $managedPidFile).Trim()
$managedPid = 0

if (-not [int]::TryParse($managedPidText, [ref] $managedPid)) {
    Remove-Item -LiteralPath $managedPidFile -Force
    throw 'The project-managed MySQL PID file was invalid and has been removed.'
}

$process = Get-Process -Id $managedPid -ErrorAction SilentlyContinue

if (-not $process) {
    Remove-Item -LiteralPath $managedPidFile -Force
    Write-Host 'The project-managed MySQL process is no longer running.'
    exit 0
}

if ($process.ProcessName -ne 'mysqld') {
    throw "Refusing to stop PID $managedPid because it is $($process.ProcessName), not mysqld."
}

Stop-Process -Id $process.Id
Wait-Process -Id $process.Id -Timeout 10 -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $managedPidFile -Force
Write-Host 'Project-managed MySQL stopped.'
