param(
    [ValidateSet('full','full-font-files','full-harfbuzz','full-hb-named','chapter','section','unit','section-direct','section-pdf-fast','section-type-fast','unit-font-files','unit-minimal','unit-xe','unit-profile','section-font-files','section-minimal','section-xe','section-profile','unit-harfbuzz','section-harfbuzz','unit-hook','section-hook','unit-structure','section-live-figure')]
    [string]$Case = 'section',
    [ValidateSet('both','de','de-cloze')][string]$Variant = 'both',
    [ValidateSet('latexmk','direct','xelatex')][string]$Engine = 'latexmk',
    [string]$Phase = 'warm',
    [switch]$Parallel,
    [switch]$NoSyncTeX,
    [string]$ExperimentRoot = 'C:\Users\alexa\.codex\visualizations\2026\09\22\01a0cb2f-336a-7392-addb-0c5ebb1289d1\tmp\pdfs\build-speed-20261009'
)

# Experimental only: isolated wrappers and outputs; never replaces final PDFs.
$ErrorActionPreference = 'Stop'
$benchmarkTimer = [System.Diagnostics.Stopwatch]::StartNew()
$projectDirectory = Split-Path -Parent $PSScriptRoot
$userCache = Join-Path ([Environment]::GetFolderPath('UserProfile')) 'AppData\Local\Temp\Mathematik1-Skript'
$fontCache = Join-Path $userCache 'texmf-cache'
$variantNames = if ($Variant -eq 'both') { @('de','de-cloze') } else { @($Variant) }

$runner = {
    param($projectDirectory,$experimentRoot,$fontCache,$caseName,$variantName,$engineName,$phaseName,$noSync)
    $ErrorActionPreference = 'Stop'
    Set-Location -LiteralPath $projectDirectory
    $env:TEXMFVAR = $fontCache
    $env:TEXMFCACHE = $fontCache
    $outputDirectory = Join-Path $experimentRoot ('pdf\' + $caseName)
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    $env:LATEXMK_OUT_DIR = $outputDirectory.Replace('\','/')
    $env:LATEXMK_AUX_DIR = $outputDirectory.Replace('\','/')
    $jobName = 'bench-' + $caseName + '-' + $variantName
    $source = Join-Path $experimentRoot ($jobName + '.tex')
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Missing fixture: $source" }
    $log = Join-Path $outputDirectory ($jobName + '.' + $phaseName + '.build.log')
    if ($engineName -eq 'latexmk') {
        $executable = (Get-Command latexmk -ErrorAction Stop).Source
        $arguments = @('-lualatex','-halt-on-error','-interaction=nonstopmode',('-synctex=' + [int](-not $noSync)),$source)
    }
    else {
        $executable = (Get-Command $(if ($engineName -eq 'xelatex') {'xelatex'} else {'lualatex'}) -ErrorAction Stop).Source
        $arguments = @('-halt-on-error','-interaction=nonstopmode','-recorder',('-synctex=' + [int](-not $noSync)),('-output-directory=' + $outputDirectory),$source)
    }
    $nativeTimer = [System.Diagnostics.Stopwatch]::StartNew()
    $ErrorActionPreference = 'Continue'
    & $executable @arguments *> $log
    $buildExit = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    $nativeTimer.Stop()
    $logText = [System.IO.File]::ReadAllText($log)
    $pageMatches = [regex]::Matches($logText,'Output written on .*?\((\d+) pages?')
    $pages = if ($pageMatches.Count) { [int]$pageMatches[$pageMatches.Count-1].Groups[1].Value } else { $null }
    $passes = if ($engineName -eq 'latexmk') { [regex]::Matches($logText,"Run number [0-9]+ of rule 'lualatex'").Count } else {1}
    $finalLog = Join-Path $outputDirectory ($jobName + '.log')
    $finalLogText = if (Test-Path -LiteralPath $finalLog) { [System.IO.File]::ReadAllText($finalLog) } else { $logText }
    [pscustomobject]@{
        Case=$caseName; Variant=$variantName; Engine=$engineName; Phase=$phaseName
        Seconds=[math]::Round($nativeTimer.Elapsed.TotalSeconds,3); Passes=$passes; Pages=$pages
        ExitCode=$buildExit; Pdf=(Join-Path $outputDirectory ($jobName + '.pdf')); Log=$log
        UndefinedReferences=($finalLogText -match 'There were undefined references')
    }
}

if ($Parallel -and $variantNames.Count -gt 1) {
    $jobs = foreach ($variantName in $variantNames) {
        Start-Job -ScriptBlock $runner -ArgumentList $projectDirectory,$ExperimentRoot,$fontCache,$Case,$variantName,$Engine,$Phase,([bool]$NoSyncTeX)
    }
    $results = @($jobs | Wait-Job | Receive-Job)
    $jobs | Remove-Job
}
else {
    $results = @(foreach ($variantName in $variantNames) {
        & $runner $projectDirectory $ExperimentRoot $fontCache $Case $variantName $Engine $Phase ([bool]$NoSyncTeX)
    })
}
$benchmarkTimer.Stop()
$summary = [pscustomobject]@{
    Case=$Case; Phase=$Phase; Parallel=[bool]$Parallel; NoSyncTeX=[bool]$NoSyncTeX
    TotalSeconds=[math]::Round($benchmarkTimer.Elapsed.TotalSeconds,3); Results=$results
}
$summary | ConvertTo-Json -Depth 5 -Compress
Write-Host ('Baudauer: {0:F3} Sekunden' -f $benchmarkTimer.Elapsed.TotalSeconds)
if ($results.Count -ne $variantNames.Count -or ($results | Where-Object ExitCode -ne 0)) { exit 1 }
exit 0
