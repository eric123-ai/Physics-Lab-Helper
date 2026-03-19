@echo off
setlocal
chcp 65001 >nul 2>nul

cd /d "%~dp0"

git --version >nul 2>nul
if errorlevel 1 (
  echo [ERROR] git not found in PATH. Install Git for Windows first.
  exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Not a git repository: %cd%
  exit /b 1
)

for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyy-MM-dd HH:mm:ss\")"') do set "MSG=%%i"

echo [1/4] git add -A
git add -A
if errorlevel 1 (
  echo [ERROR] git add failed
  exit /b 1
)

git diff --cached --quiet
if not errorlevel 1 (
  echo [INFO] No changes to commit
  exit /b 0
)

echo [2/4] git commit -m "%MSG%"
git commit -m "%MSG%"
if errorlevel 1 (
  echo [ERROR] git commit failed. If first time, run:
  echo   git config --global user.name "YOUR_NAME"
  echo   git config --global user.email "YOU@EXAMPLE.COM"
  exit /b 1
)

echo [3/4] git push
git push
if errorlevel 1 (
  echo [ERROR] git push failed. If first time, run:
  echo   git push -u origin HEAD
  exit /b 1
)

echo [4/4] Done: %MSG%
exit /b 0
