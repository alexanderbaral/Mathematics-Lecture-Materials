$ErrorActionPreference = 'Stop'

$variants = @(
    @{ File = 'build-de.tex';       Label = 'German complete' },
    @{ File = 'build-de-cloze.tex'; Label = 'German cloze' },
    @{ File = 'build-en.tex';       Label = 'English complete' },
    @{ File = 'build-en-cloze.tex'; Label = 'English cloze' }
)

$buildDirectory = Join-Path $PSScriptRoot 'build'
New-Item -ItemType Directory -Force -Path $buildDirectory | Out-Null
$texmfCacheDirectory = Join-Path $buildDirectory 'texmf-cache'
New-Item -ItemType Directory -Force -Path $texmfCacheDirectory | Out-Null
$env:TEXMFVAR = $texmfCacheDirectory
$env:TEXMFCACHE = $texmfCacheDirectory
$outDirectoryArgument = "-outdir=$buildDirectory"

$results = @()
Push-Location $PSScriptRoot
try {
    foreach ($variant in $variants) {
        Write-Host "Building $($variant.Label)..."
        & latexmk $outDirectoryArgument -g -lualatex -halt-on-error -interaction=nonstopmode $variant.File | Out-Host
        $results += [pscustomobject]@{
            Label   = $variant.Label
            Success = ($LASTEXITCODE -eq 0)
        }
    }
}
finally {
    Pop-Location
}

Write-Host ''
foreach ($result in $results) {
    if ($result.Success) {
        Write-Host "[OK] $($result.Label)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAILED] $($result.Label)" -ForegroundColor Red
    }
}

if ($results.Success -contains $false) {
    exit 1
}

exit 0
