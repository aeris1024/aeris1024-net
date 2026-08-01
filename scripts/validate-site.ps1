$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

$requiredFiles = @(
    "index.html"
    "style.css"
    "assets/avatar.jpg"
)

foreach ($relativePath in $requiredFiles) {
    $path = Join-Path $repositoryRoot $relativePath

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures.Add("Missing required file: $relativePath")
        continue
    }

    if ((Get-Item -LiteralPath $path).Length -eq 0) {
        $failures.Add("Required file is empty: $relativePath")
    }
}

$htmlPath = Join-Path $repositoryRoot "index.html"
if (Test-Path -LiteralPath $htmlPath -PathType Leaf) {
    $html = Get-Content -Raw -LiteralPath $htmlPath
    $requiredHtmlPatterns = [ordered]@{
        "doctype" = "(?i)<!doctype\s+html\s*>"
        "html"    = "(?i)<html(?:\s|>)"
        "/html"   = "(?i)</html\s*>"
        "head"    = "(?i)<head(?:\s|>)"
        "/head"   = "(?i)</head\s*>"
        "body"    = "(?i)<body(?:\s|>)"
        "/body"   = "(?i)</body\s*>"
    }

    foreach ($entry in $requiredHtmlPatterns.GetEnumerator()) {
        if ($html -notmatch $entry.Value) {
            $failures.Add("Missing basic HTML element: $($entry.Key)")
        }
    }
}

$cssPath = Join-Path $repositoryRoot "style.css"
if (Test-Path -LiteralPath $cssPath -PathType Leaf) {
    $css = Get-Content -Raw -LiteralPath $cssPath
    $cssWithoutComments = [regex]::Replace(
        $css,
        "/\*.*?\*/",
        "",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
    $openingBraces = ([regex]::Matches($cssWithoutComments, "\{")).Count
    $closingBraces = ([regex]::Matches($cssWithoutComments, "\}")).Count

    if ($openingBraces -ne $closingBraces) {
        $failures.Add("CSS braces are unbalanced: $openingBraces opening, $closingBraces closing")
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }

    exit 1
}

Write-Host "Site validation passed."
