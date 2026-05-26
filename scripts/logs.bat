@echo off
REM ログ表示スクリプト

cd /d %~dp0..

echo =====================================
echo Rails ログ表示
echo =====================================
echo.
echo 最新の100行を表示しています。
echo Ctrl+C で終了
echo.

if exist log\development.log (
    powershell -Command "Get-Content log/development.log -Tail 100 -Wait"
) else (
    echo ログファイルが見つかりません
    echo Rails を起動してからもう一度実行してください
    pause
)
