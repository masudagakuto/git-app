#!/bin/bash

set -e

echo "=========================================="
echo "Rootpro CAD解析ツール - ローカルセットアップ"
echo "=========================================="
echo ""

# Ruby バージョン確認
echo "✓ Ruby バージョン確認中..."
ruby_version=$(ruby -v)
echo "  $ruby_version"
echo ""

# Bundler インストール確認
echo "✓ Bundler インストール確認中..."
if ! command -v bundle &> /dev/null; then
  echo "  Bundler をインストール中..."
  gem install bundler
fi
echo ""

# Gem インストール
echo "✓ Gem 依存関係をインストール中..."
bundle install
echo ""

# MySQL 接続確認
echo "✓ MySQL 接続確認中..."
if mysql -u root -e "SELECT 1" > /dev/null 2>&1; then
  echo "  MySQL: 接続OK"
else
  echo "  ⚠️  MySQL に接続できません。以下を確認してください："
  echo "    - MySQL が起動しているか"
  echo "    - ユーザー/パスワードが正しいか"
  echo "    - database.yml でソケットパスが正しいか"
  echo ""
  echo "  設定例："
  echo "    macOS:   socket: /tmp/mysql.sock"
  echo "    Linux:   socket: /var/run/mysqld/mysqld.sock"
  echo ""
  exit 1
fi
echo ""

# データベースセットアップ
echo "✓ データベースをセットアップ中..."
rails db:create 2>/dev/null || echo "  (既に存在する場合はスキップ)"
rails db:migrate
echo ""

# Ollama 接続確認
echo "✓ Ollama 接続確認中..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
  echo "  Ollama: 接続OK"
  echo "  リモート："
  curl -s http://localhost:11434/api/tags | grep -o '"name":"[^"]*"' | cut -d'"' -f4 || true
else
  echo "  ⚠️  Ollama に接続できません。以下を確認してください："
  echo "    - Ollama が起動しているか: ollama serve"
  echo "    - llama2 がダウンロードされているか: ollama pull llama2"
fi
echo ""

echo "=========================================="
echo "✅ セットアップ完了！"
echo "=========================================="
echo ""
echo "以下のコマンドで Rails サーバーを起動してください："
echo ""
echo "  rails s"
echo ""
echo "ブラウザで以下にアクセス："
echo "  http://localhost:3000/cad_analyzer"
echo ""
