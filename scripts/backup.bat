@echo off
REM データベース バックアップスクリプト

setlocal enabledelayedexpansion

echo =====================================
echo Database バックアップ開始
echo =====================================
echo.

REM バックアップ先フォルダ作成
if not exist backups mkdir backups

REM 日付取得 (YYYYMMDD形式)
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)

set BACKUP_FILE=backups\git_app_backup_%mydate%.sql

echo バックアップファイル: %BACKUP_FILE%
echo.

REM MySQLダンプ実行
echo MySQL ダンプ中...
mysqldump -u root -p git_app_development > %BACKUP_FILE%

if errorlevel 1 (
    echo.
    echo ❌ バックアップに失敗しました
    echo MySQL が起動しているか確認してください
    pause
    exit /b 1
)

echo.
for /f %%A in ('dir "%BACKUP_FILE%" ^| find "%BACKUP_FILE%"') do (
    echo ✓ バックアップ完了: %%A
)
echo.
echo =====================================
echo バックアップが %BACKUP_FILE% に保存されました
echo =====================================
echo.

REM 古いバックアップ削除（7日以上前）
echo 古いバックアップを削除中...
forfiles /S /D -7 /M "git_app_backup_*.sql" /C "cmd /c if @isdir==FALSE del @file"

echo.
pause
