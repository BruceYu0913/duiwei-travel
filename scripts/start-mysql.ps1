$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $repoRoot
$runtimeRoot = Join-Path $workspaceRoot '.runtime'
$runtimeAlias = Join-Path ([IO.Path]::GetPathRoot($workspaceRoot)) 'duiwei-runtime'
$mysqlBinary = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe'
$mysqlConfig = Join-Path $runtimeAlias 'mysql\my.ini'
$port = 3307

if (-not (Test-Path -LiteralPath $mysqlBinary)) {
    throw "MySQL binary not found: $mysqlBinary"
}

if (Test-Path -LiteralPath $runtimeAlias) {
    $alias = Get-Item -Force -LiteralPath $runtimeAlias
    $target = @($alias.Target)[0]

    if ($alias.LinkType -ne 'Junction' -or $target -ne $runtimeRoot) {
        throw "Unexpected path at $runtimeAlias. Expected a junction to $runtimeRoot."
    }
} else {
    New-Item -ItemType Junction -Path $runtimeAlias -Target $runtimeRoot | Out-Null
}

$listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue

if ($listener) {
    $process = Get-Process -Id $listener.OwningProcess

    if ($process.Path -ne $mysqlBinary) {
        throw "Port $port is already used by an unexpected process: $($process.Path)"
    }

    Write-Host "DUIWEI MySQL is already running on 127.0.0.1:$port."
    exit 0
}

$process = Start-Process -FilePath $mysqlBinary -ArgumentList @("--defaults-file=$mysqlConfig") -WindowStyle Hidden -PassThru

for ($attempt = 0; $attempt -lt 30; $attempt++) {
    Start-Sleep -Milliseconds 500

    if (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) {
        Write-Host "DUIWEI MySQL started on 127.0.0.1:$port."
        exit 0
    }

    if ($process.HasExited) {
        throw "MySQL exited early with code $($process.ExitCode)."
    }
}

throw "MySQL did not start on port $port within 15 seconds."
