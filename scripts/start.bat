@echo off
REM Ollama + Rails 起動スクリプト

echo =====================================
echo Rootpro CAD解析ツール 起動
echo =====================================
echo.

REM Ollama 起動（新しいウィンドウで）
echo [1] Ollama サーバーを起動中...
start "Ollama Server" cmd /k "ollama serve"
timeout /t 3 /nobreak

REM Rails 起動（新しいウィンドウで）
echo [2] Rails サーバーを起動中...
cd /d %~dp0..
start "Rails Server" cmd /k "rails s"

echo.
echo =====================================
echo 起動完了
echo =====================================
echo.
echo ブラウザで以下にアクセス:
echo   http://localhost:3000/cad_analyzer
echo.
echo 停止する場合は各ウィンドウで Ctrl+C を押してください
echo.

pause
