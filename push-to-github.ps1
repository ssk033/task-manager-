# Push to GitHub via SSH
# Run in PowerShell: cd d:\dev\todo-list  then  .\push-to-github.ps1
# Pehle apna email set karo (niche line 11)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

git config user.email "sanidhyasingh1202@gmail.com"
git config user.name "Sanidhya Singh"

if (Test-Path .git\index.lock) { Remove-Item .git\index.lock -Force }
git add -A
git commit -m "Fix deployment: login first, trust proxy, sameSite cookie; fix formatDate; Show tasks button" 2>$null; if (-not $?) { git status; exit 1 }
git push origin main

Write-Host "`nPushed to GitHub (SSH)."
