# Run from Windows PowerShell in C:\Users\markt\Downloads\habterra-app
# Commits + pushes habterra-app directly — no more stool-app/calibrate detour.
# Vercel deploys habterra.com from the main branch of muck83/habterra-app.

Set-Location -Path "C:\Users\markt\Downloads\habterra-app"

Write-Host ""
Write-Host "=== STEP 1: Clean stale git lock files ===" -ForegroundColor Cyan
Remove-Item -Force -ErrorAction SilentlyContinue .git\index.lock
Remove-Item -Force -ErrorAction SilentlyContinue .git\HEAD.lock
Remove-Item -Force -ErrorAction SilentlyContinue .git\objects\maintenance.lock
Remove-Item -Force -ErrorAction SilentlyContinue .git\index.tmp
Get-ChildItem -Path .git\objects -Recurse -Filter "tmp_obj_*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Write-Host "  Lock files cleared (or were already gone)."

Write-Host ""
Write-Host "=== STEP 2: Pull latest main (ff-only) ===" -ForegroundColor Cyan
git fetch origin main
git pull --ff-only origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARNING: ff-only pull failed (diverged or uncommitted changes). Inspect manually." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== STEP 3: What git sees right now ===" -ForegroundColor Cyan
Write-Host "  HEAD commit:" -ForegroundColor Yellow
git log -1 --oneline
Write-Host ""
Write-Host "  Modified / untracked files (short form):" -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "=== STEP 4: Stage all tracked changes + any new files in src/ or supabase/ ===" -ForegroundColor Cyan
# -u = update all tracked files; plus explicit adds for common new-file locations.
git add -u
git add src
git add supabase
git add public
git add index.html
git add package.json
git add package-lock.json
git add vite.config.js
git add vercel.json

Write-Host ""
Write-Host "  After staging (git diff --cached --stat):" -ForegroundColor Yellow
git diff --cached --stat

$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host ""
    Write-Host "  NO STAGED CHANGES - nothing to commit. Exiting cleanly." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "=== STEP 5: Commit ===" -ForegroundColor Cyan
$msg = Read-Host "Commit message (leave blank for default)"
if (-not $msg) { $msg = "updates" }
git commit -m $msg
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  git commit failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "=== STEP 6: Push to origin/main ===" -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  git push failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "=== STEP 7: Confirm ===" -ForegroundColor Cyan
Write-Host "  New HEAD:" -ForegroundColor Yellow
git log -1 --oneline
Write-Host ""
Write-Host "  Vercel should redeploy habterra.com within ~30s." -ForegroundColor Green
Write-Host "  Watch: https://vercel.com/muck83/habterra-app" -ForegroundColor Green
