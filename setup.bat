@echo off
REM Windowsセットアップスクリプト - 管理者権限で実行必須
REM このスクリプトを右クリック → 「管理者として実行」で実行してください

setlocal enabledelayedexpansion

echo.
echo ==========================================
echo Rootpro CAD解析ツール - Windowsセットアップ
echo ==========================================
echo.

REM 管理者権限チェック
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo エラー: 管理者権限で実行してください
    echo 右クリック → 「管理者として実行」で実行してください
    pause
    exit /b 1
)

REM Ruby バージョン確認
echo [1/6] Ruby バージョン確認中...
ruby --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo エラー: Ruby がインストールされていません
    echo https://rubyinstaller.org/downloads/ から Ruby をインストールしてください
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('ruby --version') do set RUBY_VERSION=%%i
echo  %RUBY_VERSION%
echo.

REM Bundler インストール確認
echo [2/6] Bundler インストール中...
gem install bundler --silent
if errorlevel 1 (
    echo  Bundler インストール失敗
    pause
    exit /b 1
)
echo  OK
echo.

REM Gem インストール
echo [3/6] Gem 依存関係をインストール中...
call bundle install --quiet
if errorlevel 1 (
    echo  Bundle install 失敗
    echo.
    echo トラブルシューティング:
    echo 1. 以下を実行してみてください:
    echo    gem install bundler
    echo    bundle install
    echo.
    pause
    exit /b 1
)
echo  OK
echo.

REM MySQL 接続確認
echo [4/6] MySQL 接続確認中...
mysql -u root -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo  警告: MySQL に接続できません
    echo  以下を確認してください:
    echo    - MySQL が起動しているか
    echo    - ユーザー/パスワードが正しいか
    echo.
    echo MySQL が起動していない場合、以下を実行してください:
    echo    net start MySQL80
    echo  （またはコントロールパネルから MySQL を起動）
    echo.
    set SKIP_DB=1
) else (
    echo  MySQL: 接続OK
    echo.
)
echo.

REM DB セットアップ
if "%SKIP_DB%"=="" (
    echo [5/6] データベースをセットアップ中...
    call rails db:create 2>nul
    call rails db:migrate --quiet
    if errorlevel 1 (
        echo  警告: DB セットアップ中にエラーが発生しました
    ) else (
        echo  OK
    )
) else (
    echo [5/6] DB セットアップをスキップ（MySQL 未接続）
)
echo.

REM Ollama 接続確認
echo [6/6] Ollama 接続確認中...
for /f "tokens=*" %%i in ('powershell -Command "(curl -s http://localhost:11434/api/tags 2>$null | Select-String 'name' | Measure-Object).Count" 2^>nul') do set OLLAMA_CHECK=%%i
if "%OLLAMA_CHECK%"=="" (
    echo  警告: Ollama に接続できません
    echo  以下を実行してください（別ターミナル）:
    echo    ollama serve
) else (
    echo  Ollama: 接続OK
)
echo.

echo ==========================================
echo セットアップ完了！
echo ==========================================
echo.
echo 以下を実行してください:
echo.
echo ターミナル1: Ollama 起動
echo   ollama serve
echo.
echo ターミナル2: Rails 起動
echo   rails s
echo.
echo ブラウザでアクセス:
echo   http://localhost:3000/cad_analyzer
echo.

pause
