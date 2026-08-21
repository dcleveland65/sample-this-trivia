$gh  = "C:\Program Files\GitHub CLI\gh.exe"
$dir = "C:\Users\dcleveland\projects\sample-this-trivia"

Write-Host "=== GitHub Setup ===" -ForegroundColor Cyan
Write-Host "Step 1: Logging in..." -ForegroundColor Yellow
& $gh auth login --hostname github.com --git-protocol https --web

Write-Host "Step 2: Creating repo and pushing code..." -ForegroundColor Yellow
Set-Location $dir
& $gh repo create sample-this-trivia --public --source . --remote origin --push

Write-Host "Step 3: Enabling GitHub Pages..." -ForegroundColor Yellow
$body = '{"source":{"branch":"master","path":"/"}}'
& $gh api repos/'{owner}/sample-this-trivia/pages' --method POST --input - <<< $body 2>&1

Start-Sleep 5
Write-Host ""
Write-Host "GitHub Pages URL:" -ForegroundColor Green
& $gh api "repos/{owner}/sample-this-trivia" --jq '.html_url' 2>&1
Write-Host "(Pages may take 1-2 mins to go live — visit the URL above + /index.html)" -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to close"
