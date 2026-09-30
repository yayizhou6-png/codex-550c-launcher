param(
    [int]$HoldMilliseconds = 4500
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$htmlPath = Join-Path $root 'codex-550c-original\550C-source.html'
$edgePath = @(
    'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
    'C:\Program Files\Microsoft\Edge\Application\msedge.exe'
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if (-not (Test-Path -LiteralPath $htmlPath)) {
    throw "Original 550C animation was not found: $htmlPath"
}

if (-not $edgePath) {
    throw 'Microsoft Edge was not found; the original HTML animation cannot be displayed.'
}

$startApp = Get-StartApps | Where-Object {
    $_.AppID -eq 'OpenAI.Codex_2p2nqsd0c76g0!App' -or $_.Name -match 'Codex|ChatGPT'
} | Select-Object -First 1

$appId = if ($startApp) {
    $startApp.AppID
} else {
    'OpenAI.Codex_2p2nqsd0c76g0!App'
}

$profilePath = Join-Path $env:TEMP ('codex-550c-edge-' + [guid]::NewGuid().ToString('N'))
$edgeProcess = $null

try {
    New-Item -ItemType Directory -Path $profilePath -Force | Out-Null

    Start-Process -FilePath 'explorer.exe' -ArgumentList @("shell:AppsFolder\$appId") | Out-Null
    Start-Sleep -Milliseconds 250

    $fileUri = ([Uri]$htmlPath).AbsoluteUri
    $edgeArguments = @(
        "--user-data-dir=$profilePath",
        '--no-first-run',
        '--no-default-browser-check',
        '--disable-session-crashed-bubble',
        '--inprivate',
        '--disable-sync',
        '--disable-features=msEdgeSyncConsent,msImplicitSignin',
        '--start-fullscreen',
        "--app=$fileUri"
    )
    $edgeProcess = Start-Process -FilePath $edgePath -ArgumentList $edgeArguments -PassThru

    Start-Sleep -Milliseconds ([Math]::Max(1000, $HoldMilliseconds))
}
finally {
    if ($edgeProcess -and -not $edgeProcess.HasExited) {
        try {
            & taskkill.exe /PID $edgeProcess.Id /T /F *> $null
        } catch {
        }
    }

    for ($attempt = 0; $attempt -lt 8 -and (Test-Path -LiteralPath $profilePath); $attempt++) {
        try {
            [System.IO.Directory]::Delete($profilePath, $true)
        } catch {
            Start-Sleep -Milliseconds 250
        }
    }
}
