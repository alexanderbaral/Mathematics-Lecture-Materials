param(
    [ValidateSet('de','en','all')][string]$Language = 'de',
    [string[]]$Sheet = @('all'),
    [ValidateSet('on','off','both')][string]$Solutions = 'off',
    [switch]$Force,
    [switch]$Warm,
    [switch]$Incremental,
    [ValidateRange(1,16)][int]$Jobs = 4,
    [string]$Python = ''
)
$ErrorActionPreference = 'Stop'
if ($Incremental) { $Warm = $true; if ($Sheet.Count -ne 1 -or $Sheet[0] -ne 'all') { throw '-Incremental selects all registered sheets automatically.' } }
if ($Warm -and $Force) { throw 'Choose either -Warm or -Force.' }
$totalTimer = [Diagnostics.Stopwatch]::StartNew()
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$cacheRoot = if ($env:EXERCISE_SHEETS_CACHE) { $env:EXERCISE_SHEETS_CACHE } else {
    Join-Path $env:LOCALAPPDATA '_tmp_LatexCache/mathematics_exercise_sheets'
}
$cacheRoot = [IO.Path]::GetFullPath($cacheRoot)
$workingCopy = Join-Path $cacheRoot 'workspace'
New-Item -ItemType Directory -Force -Path $cacheRoot,$workingCopy | Out-Null
try { $buildLock = [IO.File]::Open((Join-Path $cacheRoot 'build.lock'), 'OpenOrCreate', 'ReadWrite', 'None') }
catch { throw 'Another build is active. Wait for it to finish.' }
try {
# Build from an up-to-date local mirror, including source images and PDFs.
# Authoritative sources stay in the repository; only this disposable mirror is pruned.
$sourceFiles = @(Get-Item -LiteralPath 'main.tex','latexmkrc') +
    @(Get-ChildItem -LiteralPath 'common','content','tools' -File -Recurse |
      Where-Object { $_.FullName -notmatch '[\\/]__pycache__[\\/]' })
$expectedFiles = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($sourceFile in $sourceFiles) {
    $relative = $sourceFile.FullName.Substring($projectRoot.Length).TrimStart([char]'\',[char]'/')
    $destination = [IO.Path]::GetFullPath((Join-Path $workingCopy $relative))
    if (-not $destination.StartsWith($workingCopy + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid cache mirror path' }
    [void]$expectedFiles.Add($destination)
    $existing = Get-Item -LiteralPath $destination -ErrorAction SilentlyContinue
    if (-not $existing -or $existing.Length -ne $sourceFile.Length -or $existing.LastWriteTimeUtc -ne $sourceFile.LastWriteTimeUtc) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
        Copy-Item -LiteralPath $sourceFile.FullName -Destination $destination -Force
    }
}
foreach ($cachedFile in Get-ChildItem -LiteralPath $workingCopy -File -Recurse) {
    $resolved = [IO.Path]::GetFullPath($cachedFile.FullName)
    if (-not $resolved.StartsWith($workingCopy + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid cache cleanup path' }
    if (-not $expectedFiles.Contains($resolved)) { Remove-Item -LiteralPath $resolved -Force }
}
Write-Host "Cache: $cacheRoot"
$preparationSeconds = $totalTimer.Elapsed.TotalSeconds
$registry = Get-Content -LiteralPath (Join-Path $workingCopy 'common/config.tex') -Raw -Encoding utf8
$entries = [regex]::Matches($registry, '(?m)^\\DeclareSheet\{([a-z_]+)\}\{([a-z_]+)\}\{(\d+)\}\{([^{}]+)\}\{([^{}]+)\}\{([^{}]+)\}')
$sheets = @($entries | ForEach-Object {
    [pscustomobject]@{Id=$_.Groups[1].Value; Chapter=$_.Groups[2].Value; Number=$_.Groups[3].Value; TitleDe=$_.Groups[4].Value.Replace('~',' '); TitleEn=$_.Groups[5].Value.Replace('~',' '); Entry=$_.Groups[6].Value}
})
if ($sheets.Count -eq 0) { throw 'No registered sheets.' }
if (@($sheets | Group-Object Id | Where-Object Count -gt 1).Count) { throw 'Duplicate sheet id.' }
foreach ($requested in $Sheet) {
    if ($requested -ne 'all' -and $requested -notin $sheets.Id) { throw "Unknown sheet: $requested" }
}
$allSheets = $sheets
if ('all' -notin $Sheet) { $sheets = @($sheets | Where-Object Id -in $Sheet) }
$languages = if ($Language -eq 'all') { @('de','en') } else { @($Language) }
$modes = if ($Solutions -eq 'both') { @('off','on') } else { @($Solutions) }
$latexmk = (Get-Command latexmk -ErrorAction Stop).Source
function Get-SheetOutputFileName {
    param([object]$Sheet, [string]$Language, [string]$Mode)
    $title = if ($Language -eq 'de') { $Sheet.TitleDe } else { $Sheet.TitleEn }
    $title = $title.Replace('~', ' ')
    $prefix = if ($Language -eq 'de') { ([char]0x00DC).ToString() + 'bungsblatt' } else { 'Exercise Sheet' }
    $fileStem = "$prefix $($Sheet.Number) - $title"
    if ($Mode -eq 'on') {
        if ($Language -eq 'de') { $fileStem += (' (mit L' + [char]0x00F6 + 'sungen)') }
        else { $fileStem += ' (with Solutions)' }
    }
    return "$fileStem.pdf"
}
function Get-CombinedOutputFileName {
    param([string]$Language, [string]$Mode)
    if ($Mode -eq 'on') {
        if ($Language -eq 'de') { return ('_' + [char]0x00DC + 'bungsblatt Alle (mit L' + [char]0x00F6 + 'sungen).pdf') }
        return '_Exercise Sheet All (with Solutions).pdf'
    }
    if ($Language -eq 'de') { return ('_' + [char]0x00DC + 'bungsblatt Alle.pdf') }
    return '_Exercise Sheet All.pdf'
}

        $pythonCandidates = if ($Python) { @($Python) } else {
            @('python', (Join-Path $env:USERPROFILE '.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'))
        }
        $pythonCommand = $null
        foreach ($candidate in $pythonCandidates) {
            if (Get-Command $candidate -ErrorAction SilentlyContinue) {
                $savedProbePreference = $ErrorActionPreference
                $ErrorActionPreference = 'Continue'
                & $candidate -c 'import pypdf' 2>$null
                $ErrorActionPreference = $savedProbePreference
                if ($LASTEXITCODE -eq 0) { $pythonCommand = $candidate; break }
            }
        }

if (-not $pythonCommand) { throw 'Python with pypdf is required.' }
$planPath = Join-Path $cacheRoot 'incremental_plan.json'
& $pythonCommand -B tools/incremental_build.py plan $projectRoot $cacheRoot $planPath
if ($LASTEXITCODE -ne 0) { throw 'Incremental planning failed.' }
$plan = Get-Content -LiteralPath $planPath -Raw -Encoding utf8 | ConvertFrom-Json

$savedVar = $env:TEXMFVAR
$savedCache = $env:TEXMFCACHE
$results = [System.Collections.Generic.List[object]]::new()
$runId = Get-Date -Format 'yyyyMMdd_HHmmssfff'
New-Item -ItemType Directory -Force -Path (Join-Path $cacheRoot 'texmf') | Out-Null
$env:TEXMFVAR = (Join-Path $cacheRoot 'texmf').Replace('\','/')
$env:TEXMFCACHE = $env:TEXMFVAR
$activeJobs = [System.Collections.Generic.List[object]]::new()
function Receive-BuildJobs {
    $finished = Wait-Job -Job @($activeJobs.ToArray()) -Any
    try {
        $items = @(Receive-Job -Job $finished -ErrorAction Stop)
        if ($finished.State -ne 'Completed' -or $items.Count -ne 1 -or -not $items[0].sheet) {
            throw "Build worker failed: $($finished.Name)"
        }
        $results.Add($items[0])
    } finally {
        [void]$activeJobs.Remove($finished)
        Remove-Job -Job $finished -Force
    }
}
try {
    # Never keep a stale overview after rebuilding any of its component sheets.
    foreach ($lang in $languages) { foreach ($mode in $modes) {
        $variant = if ($mode -eq 'on') { "${lang}_solutions" } else { $lang }
        $combined = "build/$variant/$(Get-CombinedOutputFileName $lang $mode)"
        if (-not ($Incremental -and $plan."$variant/all_exercises".reuse) -and (Test-Path -LiteralPath $combined)) { Remove-Item -LiteralPath $combined }
    } }
    foreach ($lang in $languages) { foreach ($sheetEntry in $sheets) { foreach ($mode in $modes) {
        $variant = if ($mode -eq 'on') { "${lang}_solutions" } else { $lang }
        $id = $sheetEntry.Id
        if ($Incremental -and $plan."$variant/$id".reuse) {
            Write-Host "[unchanged] $variant/$id"
            $results.Add([pscustomobject]@{sheet=$id;language=$lang;solutions=$mode;status='ok';detail="build/$variant/$(Get-SheetOutputFileName $sheetEntry $lang $mode)";seconds=0;cache_reused=$true;latex_passes=0;unchanged=$true})
            continue
        }
        while ($activeJobs.Count -ge $Jobs) { Receive-BuildJobs }
        $job = Start-Job -FilePath (Join-Path $PSScriptRoot 'build_sheet.ps1') -ArgumentList $projectRoot,$cacheRoot,$workingCopy,$latexmk,$lang,$sheetEntry,$mode,$runId,([bool]$Warm),([bool]$Force)
        $activeJobs.Add($job)

    } } }
    while ($activeJobs.Count) { Receive-BuildJobs }
    # A complete overview is produced only from a complete successful current run.
    if ($sheets.Count -eq $allSheets.Count) {
        foreach ($lang in $languages) { foreach ($mode in $modes) {
            $variant = if ($mode -eq 'on') { "${lang}_solutions" } else { $lang }
            if ($Incremental -and $plan."$variant/all_exercises".reuse) {
                Write-Host "[unchanged] $variant/all_exercises"
            $results.Add([pscustomobject]@{sheet='all_exercises';language=$lang;solutions=$mode;status='ok';detail="build/$variant/$(Get-CombinedOutputFileName $lang $mode)";seconds=0;unchanged=$true})
                continue
            }
            $combineTimer = [Diagnostics.Stopwatch]::StartNew()
            $output = "build/$variant/$(Get-CombinedOutputFileName $lang $mode)"
            $components = @($results | Where-Object { $_.language -eq $lang -and $_.solutions -eq $mode })
            $status = 'failed'
            $detail = 'Incomplete current build; no combined PDF generated.'
            if (@($components | Where-Object status -ne 'ok').Count -eq 0 -and $components.Count -eq $allSheets.Count) {
                if (-not $pythonCommand) { $detail = 'Python with pypdf required. Install pypdf or pass -Python <executable>.' }
                else {
                    $manifest = @($allSheets | ForEach-Object {
                        $title = if ($lang -eq 'de') { "Blatt $($_.Number) - $($_.TitleDe)" } else { "Sheet $($_.Number) - $($_.TitleEn)" }
                        @{path="build/$variant/$(Get-SheetOutputFileName $_ $lang $mode)";title=$title}
                    })
                    $manifestPath = Join-Path $cacheRoot "latex_runs/combined_${variant}_$runId.json"
                    [IO.File]::WriteAllText($manifestPath, (ConvertTo-Json -InputObject $manifest), [Text.UTF8Encoding]::new($false))
                    & $pythonCommand -B tools/combine_pdfs.py $manifestPath $output
                    if ($LASTEXITCODE -eq 0) { $status = 'ok'; $detail = $output }
                    else { $detail = 'PDF combination failed.' }
                }
            }
            Write-Host "[$status] $variant/all_exercises : $detail"
            $results.Add([pscustomobject]@{sheet='all_exercises';language=$lang;solutions=$mode;status=$status;detail=$detail;seconds=[math]::Round($combineTimer.Elapsed.TotalSeconds,3)})
        } }
    } else { Write-Host 'Partial build: overview removed. Build all sheets to refresh all_exercises.pdf.' }
} finally {
    foreach ($job in @($activeJobs.ToArray())) { Stop-Job -Job $job; Remove-Job -Job $job -Force }
    $env:TEXMFVAR = $savedVar
    $env:TEXMFCACHE = $savedCache
    $timing = @{incremental=[bool]$Incremental;jobs=$Jobs;warm_requested=[bool]$Warm;total_seconds=[math]::Round($totalTimer.Elapsed.TotalSeconds,3);preparation_seconds=[math]::Round($preparationSeconds,3);run_id=$runId;results=@($results.ToArray())}
    [IO.File]::WriteAllText((Join-Path $cacheRoot 'build_timing.json'), ($timing | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))
    Write-Host ('Total build time: {0:N1} s' -f $timing.total_seconds)
    $statusJson = $results | ConvertTo-Json -Depth 4
    # Cloud sync may briefly lock the status file after another local build.
    for ($statusAttempt = 0; $statusAttempt -lt 6; $statusAttempt++) {
        try {
            [IO.File]::WriteAllText((Join-Path $cacheRoot 'build_status.json'), $statusJson, [Text.UTF8Encoding]::new($false))
            break
        } catch [IO.IOException] {
            if ($statusAttempt -eq 5) { throw }
            Start-Sleep -Milliseconds (250 * [Math]::Pow(2, $statusAttempt))
        }
    }
}
& $pythonCommand -B tools/incremental_build.py finish $projectRoot $cacheRoot (Join-Path $cacheRoot 'build_status.json')
if ($LASTEXITCODE -ne 0) { throw 'Incremental state update failed.' }
if (@($results | Where-Object status -ne 'ok').Count) { exit 1 }
exit 0

} finally { $buildLock.Dispose() }
