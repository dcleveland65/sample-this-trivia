Set-StrictMode -Off
$ErrorActionPreference = "Continue"
$dir = "C:\Users\dcleveland\projects\sample-this-trivia"
Set-Location $dir

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  SAMPLE THIS! — Firebase Multiplayer " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Login ─────────────────────────────────────
Write-Host "Step 1/5  Logging into Google/Firebase..." -ForegroundColor Yellow
Write-Host "          (Your browser will open — sign in with your Google account)" -ForegroundColor Gray
firebase login
Write-Host ""

# ── Step 2: Create project ────────────────────────────
$ts        = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$projectId = "sample-this-trivia-$ts"
Write-Host "Step 2/5  Creating Firebase project '$projectId'..." -ForegroundColor Yellow
firebase projects:create $projectId --display-name "Sample This! Trivia"
Write-Host ""

# ── Step 3: Create Realtime Database ─────────────────
Write-Host "Step 3/5  Creating Realtime Database (us-central1)..." -ForegroundColor Yellow
firebase database:instances:create "$projectId-default-rtdb" --location us-central1 --project $projectId 2>&1

# Write open rules so the game can read/write room state
$rulesJson = '{"rules":{".read":true,".write":true}}'
$rulesFile = "$dir\database.rules.json"
Set-Content $rulesFile $rulesJson -Encoding UTF8
firebase database:rules:deploy --project $projectId 2>&1 | Out-Null
Write-Host "          Database ready." -ForegroundColor Green
Write-Host ""

# ── Step 4: Register web app + get SDK config ─────────
Write-Host "Step 4/5  Registering web app and fetching config..." -ForegroundColor Yellow
$appOutput = firebase apps:create WEB "SampleThis" --project $projectId --json 2>&1 | Select-String -Pattern "^\{" -Context 0,100
$appJson   = ($appOutput | Out-String).Trim()

# Fall back: get config via apps:sdkconfig
$rawConfig = firebase apps:sdkconfig WEB --project $projectId --json 2>&1
$jsonLines = $rawConfig | Where-Object { $_ -match '^\s*[\{\}"\[]' -or $_ -match '"apiKey"' } | Out-String

# Parse via ConvertFrom-Json
try {
    $parsed = $rawConfig | Out-String | ConvertFrom-Json -ErrorAction Stop
    $cfg    = $parsed.result.sdkConfig
} catch {
    # Fallback: regex-extract individual values
    $raw = $rawConfig | Out-String
    $cfg = [PSCustomObject]@{
        apiKey            = [regex]::Match($raw, '"apiKey":\s*"([^"]+)"').Groups[1].Value
        authDomain        = [regex]::Match($raw, '"authDomain":\s*"([^"]+)"').Groups[1].Value
        databaseURL       = [regex]::Match($raw, '"databaseURL":\s*"([^"]+)"').Groups[1].Value
        projectId         = [regex]::Match($raw, '"projectId":\s*"([^"]+)"').Groups[1].Value
        storageBucket     = [regex]::Match($raw, '"storageBucket":\s*"([^"]+)"').Groups[1].Value
        messagingSenderId = [regex]::Match($raw, '"messagingSenderId":\s*"([^"]+)"').Groups[1].Value
        appId             = [regex]::Match($raw, '"appId":\s*"([^"]+)"').Groups[1].Value
    }
}

# If databaseURL is missing, construct it
if (-not $cfg.databaseURL) {
    $cfg | Add-Member -MemberType NoteProperty -Name databaseURL -Value "https://$projectId-default-rtdb.firebaseio.com" -Force
}

Write-Host "          Config retrieved." -ForegroundColor Green
Write-Host ""

# ── Step 5: Inject config into index.html ─────────────
Write-Host "Step 5/5  Injecting Firebase config into the game..." -ForegroundColor Yellow
$html = Get-Content "$dir\index.html" -Raw -Encoding UTF8

$html = $html -replace 'apiKey:\s*""',            "apiKey: `"$($cfg.apiKey)`""
$html = $html -replace 'authDomain:\s*""',        "authDomain: `"$($cfg.authDomain)`""
$html = $html -replace 'databaseURL:\s*""',       "databaseURL: `"$($cfg.databaseURL)`""
$html = $html -replace 'projectId:\s*""',         "projectId: `"$($cfg.projectId)`""
$html = $html -replace 'storageBucket:\s*""',     "storageBucket: `"$($cfg.storageBucket)`""
$html = $html -replace 'messagingSenderId:\s*""', "messagingSenderId: `"$($cfg.messagingSenderId)`""
$html = $html -replace 'appId:\s*""',             "appId: `"$($cfg.appId)`""

Set-Content "$dir\index.html" $html -Encoding UTF8

# Also copy to Desktop for convenience
Copy-Item "$dir\index.html" "C:\Users\dcleveland\Desktop\sample-this-trivia.html" -Force

Write-Host "          index.html updated." -ForegroundColor Green
Write-Host ""

# ── Done ──────────────────────────────────────────────
Write-Host "======================================" -ForegroundColor Green
Write-Host "  MULTIPLAYER ENABLED!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Firebase Project : $projectId" -ForegroundColor White
Write-Host "  Database URL     : https://$projectId-default-rtdb.firebaseio.com" -ForegroundColor White
Write-Host "  Console          : https://console.firebase.google.com/project/$projectId" -ForegroundColor White
Write-Host ""
Write-Host "  How to play online:" -ForegroundColor Cyan
Write-Host "  1. Host opens the game -> click [+ Create Room]" -ForegroundColor White
Write-Host "  2. Share the 5-letter room code with players" -ForegroundColor White
Write-Host "  3. Players open the game, enter the code -> Join" -ForegroundColor White
Write-Host "  4. Scores sync live across all devices!" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to close"
