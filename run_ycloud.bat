@echo off
SETLOCAL

REM --- Détecter 7-Zip ---
WHERE 7z >nul 2>nul
IF ERRORLEVEL 1 (
    echo 7-Zip non trouve, telechargement et installation...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2301-x64.exe' -OutFile '%TEMP%\7z2301-x64.exe'"
    start /wait "" "%TEMP%\7z2301-x64.exe" /S
)

REM --- Ajouter 7-Zip au PATH si absent ---
SET "SEVENZIP_PATH=C:\Program Files\7-Zip"
echo %PATH% | findstr /I /C:"%SEVENZIP_PATH%" >nul
IF ERRORLEVEL 1 (
    setx PATH "%PATH%;%SEVENZIP_PATH%"
)

REM --- Aller dans le dossier du projet ---
cd /d "%~dp0"

REM --- Auth GitHub CLI (ignore si déjà connecté) ---
gh auth status >nul 2>nul
IF ERRORLEVEL 1 (
    echo Authentification GitHub necessaire. Suivez les instructions.
    gh auth login
)

REM --- Pull pour eviter push rejeté (ignore erreurs) ---
git pull --rebase origin main || echo Warning: git pull a echoue mais on continue

REM --- Lancer le setup (ignore erreurs) ---
bash setup_ycloud_
