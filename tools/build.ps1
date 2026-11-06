param(
    [ValidateSet('script','sheets','all')]
    [string]$Target = 'script'
)
$ErrorActionPreference = 'Stop'
$lectureRoot = Split-Path -Parent $PSScriptRoot
$requests = @()
if ($Target -in @('script','all')) {
    $requests += @{ Folder = 'Skript'; Script = 'tools/build-update.ps1'; Arguments = @() }
}
if ($Target -in @('sheets','all')) {
    $requests += @{ Folder = 'Exercise Sheets'; Script = 'tools/develop.ps1'; Arguments = @('-Once') }
}
foreach ($request in $requests) {
    $projectPath = Join-Path $lectureRoot $request.Folder
    $scriptPath = Join-Path $projectPath $request.Script
    $extraArguments = $request.Arguments
    Push-Location -LiteralPath $projectPath
    try {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath @extraArguments
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    } finally {
        Pop-Location
    }
}

