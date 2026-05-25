# ローカルマシン セットアップガイド

このガイドに従って、ローカルマシンでRailsアプリを起動できます。

## 前提条件

以下がインストール済みであることを確認してください：
- Ruby 2.6.5
- Node.js (v12以上)
- MySQL 5.5.8以上（またはMariaDB）
- Ollama（llama2ダウンロード済み）

## セットアップ手順

### 1. MySQLの起動確認

```bash
# macOS (Homebrew)
brew services start mysql

# Ubuntu/Linux
sudo service mysql start

# または起動確認
mysql -u root -p
```

### 2. データベースセットアップ

```bash
# プロジェクトフォルダに移動
cd /path/to/git-app

# Gemをインストール
bundle install

# データベース作成
rails db:create

# マイグレーション実行
rails db:migrate
```

### 3. Ollamaの起動

別のターミナルで：

```bash
# Ollama サーバー起動
ollama serve
```

サーバーが起動すると `http://localhost:11434` でアクセス可能になります。

### 4. Railsアプリ起動

```bash
# メインのアプリフォルダで
rails s

# ブラウザで以下にアクセス
# http://localhost:3000/cad_analyzer
```

## トラブルシューティング

### MySQLに接続できない

```bash
# ソケットの場所を確認
mysql --help | grep socket

# database.ymlのsocketを修正
# macOS: /tmp/mysql.sock
# Linux: /var/run/mysqld/mysqld.sock
```

### bundleコマンドが見つからない

```bash
gem install bundler
```

### Rubyバージョンが異なる

```bash
# .ruby-version がある場合、rbenvで指定バージョンに切り替え
rbenv install 2.6.5
rbenv local 2.6.5
```

### Ollamaに接続できない

- `ollama serve` が起動しているか確認
- `curl http://localhost:11434/api/tags` でテスト接続
- llama2がダウンロードされているか確認：`ollama list`

## CAD解析機能の使用方法

1. ブラウザで `http://localhost:3000/cad_analyzer` にアクセス
2. 「接続テスト」ボタンで Ollama接続を確認
3. `.rpcd` ファイルをアップロード
4. llama2がファイルを解析して結果を表示

---

問題が発生した場合、エラーメッセージを確認して報告してください。
