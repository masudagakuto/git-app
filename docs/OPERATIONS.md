# Rootpro CAD解析ツール - 運用マニュアル

## 概要

このアプリケーションは、Rootproの`.rpcd`ファイルをAI（llama2）で解析・編集補助するツールです。

## システム構成

```
Ollama (llama2)
    ↓
    ↑
Rails アプリ (http://localhost:3000)
    ↓
ブラウザ (http://localhost:3000/cad_analyzer)
```

## 日常運用

### 起動手順

```cmd
REM ターミナル1: Ollama起動
ollama serve

REM ターミナル2: Rails起動
cd C:\path\to\git-app
rails s

REM ブラウザでアクセス
http://localhost:3000/cad_analyzer
```

### 停止手順

```cmd
REM Rails停止: Ctrl+C
REM Ollama停止: Ctrl+C
```

## 定期メンテナンス

### 週次チェックリスト

- [ ] Ollama が正常に動作しているか確認
- [ ] Rails ログにエラーがないか確認
- [ ] データベースの動作確認（テストファイルアップロード）
- [ ] ディスク容量確認

### 月次チェックリスト

- [ ] Ollama モデルの更新確認：`ollama pull llama2`
- [ ] Ruby/Rails の更新確認：`bundle update`
- [ ] MySQL のバックアップ実行
- [ ] ログファイルの整理

## トラブルシューティング

### Ollama に接続できない

**症状:** 「Ollamaサーバーに接続できません」エラー

**対策:**
```cmd
REM 1. Ollama プロセス確認
tasklist | find "ollama"

REM 2. ポート確認
netstat -ano | find "11434"

REM 3. Ollama 再起動
ollama serve
```

### Rails エラー

**症状:** `rails s` でエラー

**対策:**
```cmd
REM ログ確認
tail -f log/development.log

REM Gemの再インストール
bundle install

REM DB リセット（開発環境のみ）
rails db:reset
```

### MySQL 接続エラー

**症状:** 「MySQL に接続できません」

**対策:**
```cmd
REM MySQL 起動確認
mysql -u root -p

REM MySQL 再起動
net stop MySQL80
net start MySQL80

REM パスワード確認
mysql -u root -pYourPassword
```

## バックアップ・復旧

### データベースバックアップ

```cmd
REM 毎日実行推奨
mysqldump -u root -p git_app_development > backup_%date:~0,10%.sql
```

### 復旧

```cmd
mysql -u root -p git_app_development < backup_2024-01-15.sql
```

## パフォーマンスチューニング

### Ollama 最適化

```cmd
REM llama2 の GPU利用確認
ollama list

REM メモリ設定
set OLLAMA_NUM_PARALLEL=4
ollama serve
```

### Rails 最適化

```cmd
REM 本番モード起動
RAILS_ENV=production rails s

REM キャッシュ有効化
rails cache:clear
```

## セキュリティ

### アクセス制限

本番運用時は以下を設定：

```ruby
# config/routes.rb
constraints(ip: /^192\.168\.1\./) do
  get 'cad_analyzer', to: 'cad_analyzer#index'
end
```

### ログ監視

```cmd
REM Rails ログ確認
tail -f log/development.log | grep ERROR

REM Ollama ログ確認
REM ログは Ollama のコンソール出力で確認
```

## モニタリング

### ヘルスチェック

定期的に以下を確認：

```cmd
REM Ollama ヘルスチェック
curl http://localhost:11434/api/tags

REM Rails ヘルスチェック
curl http://localhost:3000/cad_analyzer/health_check
```

## 問題報告

問題が発生した場合、以下を記録してください：

1. エラーメッセージ全文
2. 実行した操作
3. ログファイルの内容（log/development.log）
4. システム情報
   ```cmd
   ruby --version
   rails --version
   mysql --version
   ```

---

定期的にこのマニュアルを確認し、必要に応じて更新してください。
