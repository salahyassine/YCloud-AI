@echo off
SETLOCAL

REM --- Aller dans le dossier du batch ---
cd /d "%~dp0"

REM --- Vérifier si setup_ycloud.sh existe ---
IF NOT EXIST "setup_ycloud.sh" (
    echo ERREUR: setup_ycloud.sh non trouve!
    pause
    exit /b
)

REM --- Pull pour eviter push rejeté ---
git add .
git commit -m "Auto commit avant pull" 2>nul
git pull --rebase origin main || echo Warning: git pull a echoue mais on continue

REM --- Lancer le setup ---
bash "setup_ycloud.sh" || echo Warning: setup_ycloud.sh a echoue mais on continue

REM --- Créer le zip avec 7-Zip ---
"C:\Program Files\7-Zip\7z.exe" a YCloud_AI_Global.zip orchestrator deploy_global_ai.sh || echo Warning: zip a echoue mais on continue

REM --- Push vers GitHub ---
git add .
git commit -m "Auto commit from batch" 2>nul
git push origin main || echo Warning: git push a echoue mais on continue

echo.
echo === SCRIPT AUTO TERMINE ===
echo Appuyez sur ENTER pour fermer...
pause >nul
ENDLOCAL
