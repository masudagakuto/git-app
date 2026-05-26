@echo off
REM ヘルスチェック スクリプト

setlocal enabledelayedexpansion

echo =====================================
echo ヘルスチェック - Rootpro CAD解析ツール
echo =====================================
echo.

set ERRORS=0

REM Ruby チェック
echo [1] Ruby 確認中...
ruby --version >nul 2>&1
if errorlevel 1 (
    echo  ❌ Ruby が見つかりません
    set /a ERRORS+=1
) else (
    for /f "tokens=*" %%i in ('ruby --version') do (
        echo  ✓ %%i
    )
)
echo.

REM MySQL チェック
echo [2] MySQL 確認中...
mysql -u root -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo  ❌ MySQL に接続できません
    set /a ERRORS+=1
) else (
    echo  ✓ MySQL: OK
)
echo.

REM Ollama チェック
echo [3] Ollama 確認中...
powershell -Command "(curl -s http://localhost:11434/api/tags)" >nul 2>&1
if errorlevel 1 (
    echo  ❌ Ollama に接続できません
    echo     ollama serve を実行してください
    set /a ERRORS+=1
) else (
    echo  ✓ Ollama: OK
)
echo.

REM Rails チェック
echo [4] Rails 確認中...
powershell -Command "(curl -s http://localhost:3000/cad_analyzer)" >nul 2>&1
if errorlevel 1 (
    echo  ⚠ Rails が起動していません
    echo    rails s で起動してください
    set /a ERRORS+=1
) else (
    echo  ✓ Rails: OK
)
echo.

REM ディスク容量チェック
echo [5] ディスク容量確認中...
for /f "tokens=3" %%A in ('dir C:\ ^| find "bytes free"') do (
    echo  ✓ C: %%A bytes 空き容量
)
echo.

REM 結果
echo =====================================
if %ERRORS% equ 0 (
    echo ✓ すべてのチェックが完了しました
) else (
    echo ⚠ %ERRORS% 個の問題があります
)
echo =====================================
echo.

pause
