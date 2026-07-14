[CmdletBinding()]
param(
    [string] $ConfigPath,
    [switch] $CheckOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $repoRoot '.env'
$projectRuntime = Join-Path $repoRoot '.runtime'
$managedPidFile = Join-Path (Join-Path $projectRuntime 'mysql') 'managed-process.pid'

function Get-DotEnvValue {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $DefaultValue
    )

    $processValue = [Environment]::GetEnvironmentVariable($Name, 'Process')

    if (-not [string]::IsNullOrWhiteSpace($processValue)) {
        return $processValue
    }

    if (Test-Path -LiteralPath $envFile) {
        $prefix = "$Name="
        $line = Get-Content -LiteralPath $envFile |
            Where-Object { $_.StartsWith($prefix, [StringComparison]::Ordinal) } |
            Select-Object -Last 1

        if ($line) {
            return $line.Substring($prefix.Length).Trim().Trim('"').Trim("'")
        }
    }

    return $DefaultValue
}

$hostName = Get-DotEnvValue -Name 'DB_HOST' -DefaultValue '127.0.0.1'
$portText = Get-DotEnvValue -Name 'DB_PORT' -DefaultValue '3306'
$port = 0

if (-not [int]::TryParse($portText, [ref] $port) -or $port -lt 1 -or $port -gt 65535) {
    throw "Invalid DB_PORT in .env: $portText"
}

$localHosts = @('127.0.0.1', 'localhost', '::1')

if ($hostName -notin $localHosts) {
    if (Test-NetConnection -ComputerName $hostName -Port $port -InformationLevel Quiet) {
        Write-Host "MySQL is reachable at ${hostName}:$port."
        exit 0
    }

    throw "MySQL is not reachable at ${hostName}:$port. Check the DB_HOST and DB_PORT values in .env."
}

$listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($listener) {
    $listenerProcess = Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue

    if (-not $listenerProcess -or $listenerProcess.ProcessName -ne 'mysqld') {
        $processName = if ($listenerProcess) { $listenerProcess.ProcessName } else { 'unknown' }
        throw "Port $port is listening, but the process is $processName instead of mysqld."
    }

    Write-Host "MySQL is already listening at ${hostName}:$port."
    exit 0
}

if ($CheckOnly) {
    throw "MySQL is not listening at ${hostName}:$port. Start MySQL or correct DB_HOST and DB_PORT in .env."
}

if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = [Environment]::GetEnvironmentVariable('DUIWEI_MYSQL_CONFIG', 'Process')
}

if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $projectConfig = Join-Path (Join-Path $projectRuntime 'mysql') 'my.ini'
    $legacyConfig = Join-Path (Join-Path (Split-Path -Parent $repoRoot) '.runtime\mysql') 'my.ini'
    $ConfigPath = @($projectConfig, $legacyConfig) |
        Where-Object { Test-Path -LiteralPath $_ } |
        Select-Object -First 1
}

if ([string]::IsNullOrWhiteSpace($ConfigPath) -or -not (Test-Path -LiteralPath $ConfigPath)) {
    $scriptPath = Join-Path $PSScriptRoot 'start-mysql.ps1'
    throw @"
No MySQL server is listening at ${hostName}:$port, and no project-managed MySQL config was found.
Start your installed MySQL service and update DB_PORT in .env (usually 3306), or provide a config with:
  powershell -ExecutionPolicy Bypass -File "$scriptPath" -ConfigPath C:\path\to\my.ini
"@
}

$mysqlCommand = Get-Command 'mysqld.exe' -ErrorAction SilentlyContinue
$mysqlBinary = if ($mysqlCommand) { $mysqlCommand.Source } else { $null }

if (-not $mysqlBinary) {
    $mysqlBinary = @(
        (Join-Path $env:ProgramFiles 'MySQL\MySQL Server 8.4\bin\mysqld.exe'),
        (Join-Path $env:ProgramFiles 'MySQL\MySQL Server 8.0\bin\mysqld.exe')
    ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}

if (-not $mysqlBinary) {
    throw 'mysqld.exe was not found. Install MySQL 8 or add its bin directory to PATH.'
}

$resolvedConfig = (Resolve-Path -LiteralPath $ConfigPath).Path
$argument = "--defaults-file=`"$resolvedConfig`""
$process = Start-Process -FilePath $mysqlBinary -ArgumentList @($argument) -WindowStyle Hidden -PassThru

for ($attempt = 0; $attempt -lt 30; $attempt++) {
    Start-Sleep -Milliseconds 500

    $listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if ($listener) {
        $pidDirectory = Split-Path -Parent $managedPidFile
        New-Item -ItemType Directory -Path $pidDirectory -Force | Out-Null
        Set-Content -LiteralPath $managedPidFile -Value $process.Id -NoNewline
        Write-Host "Project-managed MySQL started at ${hostName}:$port."
        exit 0
    }

    if ($process.HasExited) {
        throw "MySQL exited early with code $($process.ExitCode). Check the log configured in $resolvedConfig."
    }
}

if (-not $process.HasExited) {
    Stop-Process -Id $process.Id -ErrorAction SilentlyContinue
}

throw "MySQL did not start on port $port within 15 seconds."
