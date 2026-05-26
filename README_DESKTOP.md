# Rootpro CAD解析ツール

**AI（llama2）で Rootpro の `.rpcd` ファイルを解析・編集補助するツール**

## クイックスタート

### 1️⃣ 起動

```
scripts\start.bat
```

別々のウィンドウで Ollama と Rails が起動します。

### 2️⃣ ブラウザアクセス

```
http://localhost:3000/cad_analyzer
```

### 3️⃣ ファイル解析

1. 「接続テスト」ボタンで Ollama接続確認
2. `.rpcd` ファイルをアップロード
3. AI が内容を解析して結果を表示

---

## 便利なツール

### ヘルスチェック
```
scripts\healthcheck.bat
```
システムが正常に動作しているか確認します。

### データベースバックアップ
```
scripts\backup.bat
```
毎日実行して、データを保護してください。

### ログ確認
```
scripts\logs.bat
```
最新のエラーログをリアルタイム表示します。

---

## トラブル対応

### 起動しない場合

1. ヘルスチェック実行
   ```
   scripts\healthcheck.bat
   ```

2. 詳細マニュアル確認
   ```
   docs\OPERATIONS.md
   ```

3. それでも駄目なら、以下を確認
   - Ollama が起動しているか
   - MySQL が起動しているか
   - ポート 3000, 11434 が他で使われていないか

### Ollama に接続できない

```cmd
REM Ollama の起動確認
ollama serve

REM llama2 のインストール確認
ollama list
```

---

## 定期メンテナンス

### 毎日
- [ ] start.bat で起動
- [ ] 解析テスト
- [ ] backup.bat でバックアップ

### 毎週
- [ ] healthcheck.bat でシステム確認
- [ ] ログ確認

### 毎月
- [ ] Ollama 更新：`ollama pull llama2`
- [ ] Bundle 更新：`bundle update`

詳細は `OPERATIONS_CHECKLIST.md` を参照してください。

---

## ドキュメント

| ファイル | 内容 |
|---------|------|
| `SETUP_WINDOWS.md` | 詳細なインストール手順 |
| `OPERATIONS_CHECKLIST.md` | 日次・月次チェックリスト |
| `docs/OPERATIONS.md` | 詳細な運用マニュアル |
| `QUICK_START_WINDOWS.txt` | クイックリファレンス |

---

## システム要件

- Windows 10/11
- Ruby 2.6.5以上
- MySQL 5.5.8以上
- Ollama（llama2ダウンロード済み）
- 空き容量：10GB以上

---

## よくある質問

**Q: Ollama に接続できない**
A: `ollama serve` が起動しているか確認してください。

**Q: アップロードしたファイルはどこに保存される？**
A: `/tmp` フォルダに一時保存されます。

**Q: 解析結果の精度を上げたい**
A: `ollama pull mistral` でより高度なモデルをインストールできます。

**Q: 本番環境で運用したい**
A: `docs/OPERATIONS.md` のセキュリティセクションを参照してください。

---

## サポート

問題が発生した場合：

1. `scripts\healthcheck.bat` で状態確認
2. `scripts\logs.bat` でエラーログ確認
3. `docs/OPERATIONS.md` のトラブルシューティング確認

---

**作成日:** 2026-05-26  
**バージョン:** 1.0.0  
**ステータス:** 本番運用開始
