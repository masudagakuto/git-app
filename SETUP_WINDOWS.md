# Windows セットアップガイド

Rootpro CAD解析ツールをWindowsで実行するための完全セットアップガイドです。

## 前提条件

以下をインストールする必要があります：
- Ruby 2.6.5以上
- Git for Windows
- MySQL 5.5.8以上
- Ollama（既にダウンロード済み）

## セットアップ手順

### ステップ1: Rubyのインストール

1. https://rubyinstaller.org/downloads/ にアクセス
2. **Ruby+Devkit 2.6.5** をダウンロード
3. インストーラーを実行
   - 「Add Ruby executables to your PATH」にチェック ✓
   - 「Associate .rb and .rbw files with this Ruby installation」にチェック ✓
4. インストール後、コマンドプロンプトで確認：
   ```cmd
   ruby --version
   ```

### ステップ2: Git for Windowsのインストール

1. https://git-scm.com/download/win からダウンロード
2. インストーラーを実行（デフォルト設定でOK）
3. インストール後、確認：
   ```cmd
   git --version
   ```

### ステップ3: MySQLのインストール

1. https://dev.mysql.com/downloads/mysql/ からダウンロード
2. インストーラーを実行
3. インストール中に以下を設定：
   - MySQL Server: Port 3306
   - MySQL Workbench（オプション）
   - User: `root`
   - Password: 空（またはメモしておく）
4. インストール後、確認：
   ```cmd
   mysql -u root -p
   # パスワードなしで Enter キーを押す
   mysql> exit
   ```

### ステップ4: 自動セットアップ実行

1. **管理者として PowerShell またはコマンドプロンプトを開く**
   - スタート → 「PowerShell」を右クリック → 「管理者として実行」
   - または「コマンドプロンプト」を右クリック → 「管理者として実行」

2. プロジェクトフォルダに移動：
   ```cmd
   cd C:\path\to\git-app
   ```

3. セットアップスクリプトを実行：
   ```cmd
   setup.bat
   ```

スクリプトが以下を自動実行します：
- ✅ Ruby/Bundler インストール確認
- ✅ Gem 依存関係インストール
- ✅ MySQL 接続確認
- ✅ データベース作成・マイグレーション
- ✅ Ollama 接続確認

## 手動セットアップ（スクリプト失敗時）

管理者権限のコマンドプロンプトで：

```cmd
cd C:\path\to\git-app

REM Bundler インストール
gem install bundler

REM Gem インストール
bundle install

REM DB セットアップ
rails db:create
rails db:migrate
```

## Railsの起動

### ターミナル1: Ollama起動
```cmd
ollama serve
```

### ターミナル2: Rails起動
```cmd
cd C:\path\to\git-app
rails s
```

### ブラウザでアクセス
```
http://localhost:3000/cad_analyzer
```

## トラブルシューティング

### Ruby コマンドが見つからない
- Rubyがインストールされているか確認
- Rubyの PATH が通っているか確認
- コンピューターを再起動

### Bundle インストール失敗
```cmd
gem install bundler
bundle install
```

### MySQL 接続エラー
```cmd
REM パスワードなしで接続確認
mysql -u root -p
REM （Enterキーを押す）

REM パスワード設定済みの場合
mysql -u root -pYourPassword
```

### Ollama 接続エラー
- `ollama serve` が起動しているか確認
- `ollama list` で llama2 がダウンロードされているか確認
- ポート 11434 がブロックされていないか確認

---

問題が発生した場合、エラーメッセージを報告してください。
