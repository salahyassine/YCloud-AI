@echo off
SETLOCAL

REM --- Vérifie si 7-Zip est installé ---
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

REM --- Authentification GitHub CLI si nécessaire ---
gh auth status >nul 2>nul
IF ERRORLEVEL 1 (
    echo Authentification GitHub necessaire. Suivez les instructions.
    gh auth login
)

REM --- Pull pour eviter le push rejeté ---
git pull --rebase origin main

REM --- Lancer le setup ---
bash setup_ycloud.sh

REM --- Créer le zip avec 7-Zip ---
7z a YCloud_AI_Global.zip orchestrator deploy_global_ai.sh

REM --- Ajouter, commit et push ---
git add .
git commit -m "Auto commit from run_ycloud script" 2>nul
git push origin main

echo.
echo === SCRIPT TERMINE ===
echo Appuyez sur ENTER pour fermer...
pause >nul
ENDLOCAL
