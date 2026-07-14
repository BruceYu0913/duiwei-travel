$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$mysqlBinary = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe'
$port = 3307
$listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue

if (-not $listener) {
    Write-Host "DUIWEI MySQL is not running."
    exit 0
}

$process = Get-Process -Id $listener.OwningProcess

if ($process.Path -ne $mysqlBinary) {
    throw "Refusing to stop unexpected process on port ${port}: $($process.Path)"
}

Stop-Process -Id $process.Id
Wait-Process -Id $process.Id -Timeout 10 -ErrorAction SilentlyContinue
Write-Host "DUIWEI MySQL stopped."
