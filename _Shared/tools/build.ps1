param(
    [ValidateSet('script','sheets','all')][string]$Target = 'script',
    [switch]$Status,
    [switch]$Wait
)
$ErrorActionPreference = 'Stop'
$commandArgs = @((Join-Path $PSScriptRoot 'build.py'))
if ($Status) { $commandArgs += 'status' } else { $commandArgs += 'update' }
$commandArgs += @('--product',$Target)
if ($Wait) { $commandArgs += '--wait' }
& python @commandArgs
exit $LASTEXITCODE

