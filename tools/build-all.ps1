param(
    [switch]$Force,
    [switch]$CleanCache
)

$ErrorActionPreference = 'Stop'
$buildTimer = [System.Diagnostics.Stopwatch]::StartNew()
try {

$projectRoot = Split-Path -Parent $PSScriptRoot
$fileHashes = @{}

# In-memory only: every build still checks file contents, not timestamps.
function Get-BuildFileHash([string]$Path) {
    if (-not $fileHashes.ContainsKey($Path)) {
        $fileHashes[$Path] = if ([System.IO.File]::Exists($Path)) {
            (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        }
        else { $null }
    }
    return $fileHashes[$Path]
}

# Recorder inputs include nested TeX files and images. Track project sources,
# not TeX Live packages or generated build/cache files. Missing recorder data
# deliberately causes one rebuild of figures created by older script versions.
function Get-TikzDependencyFingerprint([string]$RecorderFile, [switch]$Refresh) {
    $dependencyFile = [System.IO.Path]::ChangeExtension($RecorderFile, '.deps')
    if (-not $Refresh -and [System.IO.File]::Exists($dependencyFile)) {
        $inputs = [System.IO.File]::ReadAllLines($dependencyFile)
    }
    else {
        if (-not [System.IO.File]::Exists($RecorderFile)) { return $null }
        $rootPrefix = $projectRoot.TrimEnd('\') + '\'
        $buildPrefix = Join-Path $rootPrefix 'build\'
        $inputs = @([System.IO.File]::ReadAllLines($RecorderFile) | ForEach-Object {
            if ($_.StartsWith('INPUT ')) {
                $inputPath = $_.Substring(6).Replace('/', '\')
                if (-not [System.IO.Path]::IsPathRooted($inputPath)) {
                    $inputPath = Join-Path $projectRoot $inputPath
                }
                $inputPath = [System.IO.Path]::GetFullPath($inputPath)
                if ($inputPath.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase) -and
                    -not $inputPath.StartsWith($buildPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $inputPath
                }
            }
        } | Sort-Object -Unique)
        # Existing recorder files migrate without recompiling the figures.
        [System.IO.File]::WriteAllLines($dependencyFile, [string[]]$inputs)
    }
    if ($inputs.Count -eq 0) { return $null }
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($inputPath in $inputs) {
        $inputHash = Get-BuildFileHash $inputPath
        if (-not $inputHash) { return $null }
        $lines.Add(('{0}:{1}' -f $inputPath, $inputHash))
    }
    $hash = [System.Security.Cryptography.SHA256]::Create()
    try {
        [System.BitConverter]::ToString(
            $hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes(($lines -join "`n")))
        ).Replace('-', '').ToLowerInvariant()
    }
    finally { $hash.Dispose() }
}

$variants = @(
    @{ File = 'tools/build-de.tex';       Label = 'German complete'; Language = 'de'; Cloze = 'false' },
    @{ File = 'tools/build-de-cloze.tex'; Label = 'German cloze';    Language = 'de'; Cloze = 'true' }
    # Enable the English variants when synchronization from the German master begins.
    # @{ File = 'tools/build-en.tex';       Label = 'English complete'; Language = 'en'; Cloze = 'false' },
    # @{ File = 'tools/build-en-cloze.tex'; Label = 'English cloze';    Language = 'en'; Cloze = 'true' }
)

$buildDirectory = Join-Path $projectRoot 'build'
New-Item -ItemType Directory -Force -Path $buildDirectory | Out-Null

$localAppDataDirectory = [Environment]::GetFolderPath('LocalApplicationData')
$localCacheDirectory = Join-Path $localAppDataDirectory '_tmp_LatexCache\Mathematik1-Skript\build-cache'
$expectedLocalCacheDirectory = [System.IO.Path]::GetFullPath(
    (Join-Path $localAppDataDirectory '_tmp_LatexCache\Mathematik1-Skript\build-cache')
)
$localCacheDirectory = [System.IO.Path]::GetFullPath($localCacheDirectory)
if ($localCacheDirectory -ne $expectedLocalCacheDirectory) {
    throw "Unexpected local cache path: $localCacheDirectory"
}

if ($CleanCache) {
    if (Test-Path -LiteralPath $localCacheDirectory) {
        $resolvedLocalCacheDirectory = (Resolve-Path -LiteralPath $localCacheDirectory).Path
        if ($resolvedLocalCacheDirectory -ne $expectedLocalCacheDirectory) {
            throw "Refusing to remove unexpected cache path: $resolvedLocalCacheDirectory"
        }
        Remove-Item -LiteralPath $resolvedLocalCacheDirectory -Recurse -Force
        Write-Host "Removed local LaTeX cache: $resolvedLocalCacheDirectory"
    }
    else {
        Write-Host "Local LaTeX cache is already empty: $localCacheDirectory"
    }
    exit 0
}

New-Item -ItemType Directory -Force -Path $localCacheDirectory | Out-Null

# Standalone TikZ resources are cached per build variant. Changes to shared
# LaTeX/TikZ infrastructure invalidate the complete cache automatically.
# TODO: Remove standalone TikZ caching and this cache management once the lecture
# script is finished and fast incremental authoring builds are no longer needed.
$tikzCacheDirectory = Join-Path $localCacheDirectory 'tikz'
$tikzFingerprintFile = Join-Path $localCacheDirectory 'tikz-global.sha256'
$globalTikzInputs = @(
    Get-ChildItem -LiteralPath (Join-Path $projectRoot 'common') -Filter '*.tex' -File |
        Sort-Object -Property FullName
    Get-Item -LiteralPath (Join-Path $projectRoot 'tools/build-tikz.tex')
)
$fingerprintLines = foreach ($file in $globalTikzInputs) {
    '{0}:{1}' -f $file.FullName, (Get-BuildFileHash $file.FullName)
}
$sha256 = [System.Security.Cryptography.SHA256]::Create()
try {
    $fingerprintBytes = [System.Text.Encoding]::UTF8.GetBytes(($fingerprintLines -join "`n"))
    $tikzFingerprint = -join ($sha256.ComputeHash($fingerprintBytes) | ForEach-Object { $_.ToString('x2') })
}
finally {
    $sha256.Dispose()
}

$storedTikzFingerprint = if (Test-Path -LiteralPath $tikzFingerprintFile) {
    (Get-Content -LiteralPath $tikzFingerprintFile -Raw).Trim()
}
else {
    ''
}

if ($storedTikzFingerprint -ne $tikzFingerprint -and (Test-Path -LiteralPath $tikzCacheDirectory)) {
    $resolvedLocalCacheDirectory = (Resolve-Path -LiteralPath $localCacheDirectory).Path
    $resolvedTikzCacheDirectory = (Resolve-Path -LiteralPath $tikzCacheDirectory).Path
    if ((Split-Path -Parent $resolvedTikzCacheDirectory) -ne $resolvedLocalCacheDirectory -or
        (Split-Path -Leaf $resolvedTikzCacheDirectory) -ne 'tikz') {
        throw "Unexpected TikZ cache path: $resolvedTikzCacheDirectory"
    }
    Write-Host 'Shared TikZ infrastructure changed; rebuilding all cached figures.'
    Remove-Item -LiteralPath $resolvedTikzCacheDirectory -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $tikzCacheDirectory | Out-Null
foreach ($variant in $variants) {
    $jobName = [System.IO.Path]::GetFileNameWithoutExtension($variant.File)
    New-Item -ItemType Directory -Force -Path (Join-Path $tikzCacheDirectory $jobName) | Out-Null
}
Set-Content -LiteralPath $tikzFingerprintFile -Value $tikzFingerprint -Encoding ascii

$tikzCachePathForTex = $tikzCacheDirectory.Replace('\', '/')
$tikzCachePathFile = Join-Path $buildDirectory 'tikz-cache-path.tex'
$tikzCachePathDefinition = "\renewcommand{\TikzCacheRoot}{$tikzCachePathForTex/\TikzCacheVariant}"
$storedTikzCachePathDefinition = if (Test-Path -LiteralPath $tikzCachePathFile) {
    (Get-Content -LiteralPath $tikzCachePathFile -Raw).Trim()
}
else {
    ''
}
if ($storedTikzCachePathDefinition -ne $tikzCachePathDefinition) {
    Set-Content -LiteralPath $tikzCachePathFile -Encoding utf8 -Value $tikzCachePathDefinition
}

$texmfCacheDirectory = Join-Path $localCacheDirectory 'texmf-cache'
New-Item -ItemType Directory -Force -Path $texmfCacheDirectory | Out-Null
$env:TEXMFVAR = $texmfCacheDirectory
$env:TEXMFCACHE = $texmfCacheDirectory
$auxDirectory = Join-Path $localCacheDirectory 'latex-aux'
New-Item -ItemType Directory -Force -Path $auxDirectory | Out-Null
$env:LATEXMK_OUT_DIR = $auxDirectory.Replace('\', '/')
$latexmk = (Get-Command latexmk -ErrorAction Stop).Source
$lualatex = (Get-Command lualatex -ErrorAction Stop).Source
$latexmkArguments = @(
    '-lualatex',
    '-halt-on-error',
    '-interaction=nonstopmode'
)
if ($Force) {
    $latexmkArguments = @('-g') + $latexmkArguments
}

$tikzSources = @(
    Get-ChildItem -LiteralPath (Join-Path $projectRoot 'content/resources') -Recurse -Filter '*.tex' -File |
        Where-Object {
            $_.Directory.Name -eq 'tikz' -and
            # These sources are parameterized by caller-defined commands.
            $_.BaseName -notin @('number_set_inclusions', 'parameterized_line_representation')
        } |
        Sort-Object -Property FullName
)
$duplicateTikzNames = $tikzSources | Group-Object -Property BaseName | Where-Object { $_.Count -gt 1 }
if ($duplicateTikzNames) {
    throw "TikZ cache filenames must be unique: $($duplicateTikzNames.Name -join ', ')"
}
$validFigureNames = @($tikzSources | ForEach-Object { $_.BaseName })
$activeCacheVariants = @($variants | ForEach-Object {
    [System.IO.Path]::GetFileNameWithoutExtension($_.File)
})

# Remove cache variants and figure files that no longer have an active build or
# a corresponding standalone TikZ source.
Get-ChildItem -LiteralPath $tikzCacheDirectory -Directory | ForEach-Object {
    if ($_.Name -notin $activeCacheVariants) {
        if ($_.Parent.FullName -ne $tikzCacheDirectory) {
            throw "Unexpected stale TikZ cache path: $($_.FullName)"
        }
        Remove-Item -LiteralPath $_.FullName -Recurse -Force
    }
}
foreach ($activeCacheVariant in $activeCacheVariants) {
    $activeVariantDirectory = Join-Path $tikzCacheDirectory $activeCacheVariant
    Get-ChildItem -LiteralPath $activeVariantDirectory -File | ForEach-Object {
        if ($_.BaseName -notin $validFigureNames) {
            if ($_.DirectoryName -ne $activeVariantDirectory) {
                throw "Unexpected stale TikZ cache file: $($_.FullName)"
            }
            Remove-Item -LiteralPath $_.FullName -Force
        }
    }
}

foreach ($variant in $variants) {
    $jobName = [System.IO.Path]::GetFileNameWithoutExtension($variant.File)
    $variantTikzCacheDirectory = Join-Path $tikzCacheDirectory $jobName
    Write-Host "Updating TikZ cache for $($variant.Label)..."

    foreach ($source in $tikzSources) {
        $figureName = $source.BaseName
        $figurePdf = Join-Path $variantTikzCacheDirectory "$figureName.pdf"
        $figureFingerprintFile = Join-Path $variantTikzCacheDirectory "$figureName.sha256"
        $figureRecorderFile = Join-Path $variantTikzCacheDirectory "$figureName.fls"
        $dependencyFingerprint = Get-TikzDependencyFingerprint $figureRecorderFile
        $sourceFingerprint = Get-BuildFileHash $source.FullName
        $figureFingerprint = "$tikzFingerprint`:$sourceFingerprint`:$($variant.Language)`:$($variant.Cloze)`:$dependencyFingerprint"
        $storedFigureFingerprint = if (Test-Path -LiteralPath $figureFingerprintFile) {
            (Get-Content -LiteralPath $figureFingerprintFile -Raw).Trim()
        }
        else {
            ''
        }

        if ($dependencyFingerprint -and $storedFigureFingerprint -eq $figureFingerprint -and (Test-Path -LiteralPath $figurePdf)) {
            continue
        }

        Write-Host "  Rebuilding $figureName"
        $projectRootPrefix = $projectRoot.TrimEnd('\') + '\'
        if (-not $source.FullName.StartsWith($projectRootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Unexpected TikZ source path: $($source.FullName)"
        }
        $relativeSource = $source.FullName.Substring($projectRootPrefix.Length).Replace('\', '/')
        $texCommand = "\def\ScriptLanguage{$($variant.Language)}\def\ClozeMode{$($variant.Cloze)}\def\TikzCacheVariant{$jobName}\def\TikzSource{$relativeSource}\input{tools/build-tikz.tex}"
        $figureBuildLog = Join-Path $variantTikzCacheDirectory "$figureName.build.log"
        Set-Location -LiteralPath $projectRoot
        & $lualatex '-recorder' '-halt-on-error' '-interaction=nonstopmode' "-output-directory=$variantTikzCacheDirectory" "-jobname=$figureName" $texCommand *> $figureBuildLog
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $figurePdf)) {
            Write-Host "[FAILED] TikZ figure $figureName for $($variant.Label)" -ForegroundColor Red
            Get-Content -LiteralPath $figureBuildLog | Out-Host
            exit 1
        }
        $dependencyFingerprint = Get-TikzDependencyFingerprint $figureRecorderFile -Refresh
        if (-not $dependencyFingerprint) {
            throw "Missing or incomplete recorder inputs for TikZ figure $figureName"
        }
        $figureFingerprint = "$tikzFingerprint`:$sourceFingerprint`:$($variant.Language)`:$($variant.Cloze)`:$dependencyFingerprint"
        Set-Content -LiteralPath $figureFingerprintFile -Value $figureFingerprint -Encoding ascii
        @('.aux', '.log') | ForEach-Object {
            $temporaryFigureFile = Join-Path $variantTikzCacheDirectory "$figureName$_"
            if (Test-Path -LiteralPath $temporaryFigureFile) {
                Remove-Item -LiteralPath $temporaryFigureFile -Force
            }
        }
    }
}

$failed = $false
foreach ($variant in $variants) {
    $jobName = [System.IO.Path]::GetFileNameWithoutExtension($variant.File)
    $log = Join-Path $buildDirectory "$jobName.build.log"

    Write-Host "Building $($variant.Label)..."
    Set-Location -LiteralPath $projectRoot
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & $latexmk @latexmkArguments $variant.File *> $log
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousErrorActionPreference

    if ($exitCode -eq 0) {
        $builtPdf = Join-Path $auxDirectory "$jobName.pdf"
        if (-not (Test-Path -LiteralPath $builtPdf)) {
            throw "Expected PDF was not created: $builtPdf"
        }
        Copy-Item -LiteralPath $builtPdf -Destination (Join-Path $buildDirectory "$jobName.pdf") -Force

        # LaTeX Workshop needs the SyncTeX sidecar next to the PDF for
        # inverse search (double-click in the internal PDF viewer).
        $builtSyncTeX = Join-Path $auxDirectory "$jobName.synctex.gz"
        if (-not (Test-Path -LiteralPath $builtSyncTeX)) {
            throw "Expected SyncTeX data was not created: $builtSyncTeX"
        }
        Copy-Item -LiteralPath $builtSyncTeX -Destination (Join-Path $buildDirectory "$jobName.synctex.gz") -Force
        Write-Host "[OK] $($variant.Label)" -ForegroundColor Green
    }
    else {
        $failed = $true
        Write-Host "[FAILED] $($variant.Label)" -ForegroundColor Red
        Get-Content -LiteralPath $log | Out-Host
    }
}

if ($failed) {
    exit 1
}

exit 0
}
finally {
    $buildTimer.Stop()
    Write-Host ('Total build time: {0:F2} s' -f $buildTimer.Elapsed.TotalSeconds)
}
