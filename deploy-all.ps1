$ErrorActionPreference = "Continue"
$gh  = "C:\Program Files\GitHub CLI\gh.exe"
$dir = "C:\Users\dcleveland\projects\sample-this-trivia"
Set-Location $dir

function Banner($msg, $color="Cyan") {
    Write-Host ""
    Write-Host ("=" * 50) -ForegroundColor $color
    Write-Host "  $msg" -ForegroundColor $color
    Write-Host ("=" * 50) -ForegroundColor $color
    Write-Host ""
}

# ── STEP 1: GITHUB ──────────────────────────────────────
Banner "STEP 1 OF 2 — GitHub" "Cyan"
Write-Host "Your browser will open. Sign in and click 'Authorize GitHub CLI'." -ForegroundColor Yellow
Write-Host ""
& $gh auth login --hostname github.com --git-protocol https --web

# Check it worked
$authOk = (& $gh auth status 2>&1) -match "Logged in"
if (-not $authOk) {
    Write-Host "GitHub auth didn't complete. Re-run this script and try again." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}
Write-Host "GitHub: logged in!" -ForegroundColor Green

# Create repo (ignore error if already exists)
Write-Host "Creating repository 'sample-this-trivia'..." -ForegroundColor Yellow
& $gh repo create sample-this-trivia --public --source . --remote origin --push 2>&1

# If remote already exists just push
git push origin master 2>&1 | Out-Null

# Enable GitHub Pages
Write-Host "Enabling GitHub Pages..." -ForegroundColor Yellow
& $gh api "repos/{owner}/sample-this-trivia/pages" --method POST `
    -F "source[branch]=master" -F "source[path]=/" 2>&1 | Out-Null
Start-Sleep 3
$pagesUrl = & $gh api "repos/{owner}/sample-this-trivia" --jq ".html_url" 2>&1
Write-Host ""
Write-Host "  GitHub repo  : $pagesUrl" -ForegroundColor Green
Write-Host "  GitHub Pages : $pagesUrl (may take 2 min to go live)" -ForegroundColor Green

# ── STEP 2: NETLIFY ─────────────────────────────────────
Banner "STEP 2 OF 2 — Netlify" "Magenta"
Write-Host "Your browser will open again. Click 'Authorize' for Netlify." -ForegroundColor Yellow
Write-Host ""
netlify login

Write-Host "Deploying to Netlify..." -ForegroundColor Yellow
$result = netlify deploy --dir . --prod --message "Sample This! v$(Get-Date -Format 'yyyy-MM-dd')" 2>&1
Write-Host $result

# Extract the live URL
$liveUrl = ($result | Select-String "Website URL.*https://").ToString() -replace ".*https://", "https://"
if (-not $liveUrl) {
    $liveUrl = ($result | Select-String "https://.*\.netlify\.app").Matches[0].Value
}

Banner "ALL DONE!" "Green"
Write-Host "  GitHub repo  : $pagesUrl" -ForegroundColor White
Write-Host "  Live game    : $liveUrl" -ForegroundColor White
Write-Host ""
Write-Host "  Share either URL — the Netlify link works immediately." -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to close"
