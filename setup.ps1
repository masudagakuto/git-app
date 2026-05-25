# Windows PowerShell セットアップスクリプト
# 管理者権限で実行: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

#Requires -RunAsAdministrator

Write-Host "=========================================="
Write-Host "Rootpro CAD解析ツール - Windows PowerShell セットアップ"
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# Ruby バージョン確認
Write-Host "[1/6] Ruby バージョン確認中..." -ForegroundColor Cyan
try {
    $rubyVersion = ruby --version
    Write-Host "  $rubyVersion" -ForegroundColor Green
} catch {
    Write-Host "  エラー: Ruby がインストールされていません" -ForegroundColor Red
    Write-Host "  https://rubyinstaller.org/downloads/ から Ruby をインストールしてください" -ForegroundColor Yellow
    Read-Host "Enter キーを押して終了"
    exit 1
}
Write-Host ""

# Bundler インストール
Write-Host "[2/6] Bundler インストール中..." -ForegroundColor Cyan
gem install bundler --silent
Write-Host "  OK" -ForegroundColor Green
Write-Host ""

# Gem インストール
Write-Host "[3/6] Gem 依存関係をインストール中..." -ForegroundColor Cyan
bundle install
Write-Host "  OK" -ForegroundColor Green
Write-Host ""

# MySQL 接続確認
Write-Host "[4/6] MySQL 接続確認中..." -ForegroundColor Cyan
try {
    mysql -u root -e "SELECT 1;" | Out-Null
    Write-Host "  MySQL: 接続OK" -ForegroundColor Green
    $skipDb = $false
} catch {
    Write-Host "  警告: MySQL に接続できません" -ForegroundColor Yellow
    Write-Host "  以下を確認してください:" -ForegroundColor Yellow
    Write-Host "    - MySQL が起動しているか" -ForegroundColor Yellow
    Write-Host "    - ユーザー/パスワードが正しいか" -ForegroundColor Yellow
    $skipDb = $true
}
Write-Host ""

# DB セットアップ
Write-Host "[5/6] データベースをセットアップ中..." -ForegroundColor Cyan
if (-not $skipDb) {
    rails db:create
    rails db:migrate
    Write-Host "  OK" -ForegroundColor Green
} else {
    Write-Host "  DB セットアップをスキップ（MySQL 未接続）" -ForegroundColor Yellow
}
Write-Host ""

# Ollama 接続確認
Write-Host "[6/6] Ollama 接続確認中..." -ForegroundColor Cyan
try {
    $response = curl -s http://localhost:11434/api/tags
    if ($response) {
        Write-Host "  Ollama: 接続OK" -ForegroundColor Green
    } else {
        Write-Host "  警告: Ollama に接続できません" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  警告: Ollama に接続できません" -ForegroundColor Yellow
    Write-Host "  以下を実行してください（別ターミナル）:" -ForegroundColor Yellow
    Write-Host "    ollama serve" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ セットアップ完了！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "以下を実行してください:" -ForegroundColor Cyan
Write-Host ""
Write-Host "ターミナル1: Ollama 起動" -ForegroundColor Yellow
Write-Host "  ollama serve" -ForegroundColor White
Write-Host ""
Write-Host "ターミナル2: Rails 起動" -ForegroundColor Yellow
Write-Host "  rails s" -ForegroundColor White
Write-Host ""
Write-Host "ブラウザでアクセス:" -ForegroundColor Yellow
Write-Host "  http://localhost:3000/cad_analyzer" -ForegroundColor White
Write-Host ""

Read-Host "Enter キーを押して終了"
