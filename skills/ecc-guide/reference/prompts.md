# ECCコマンド プロンプト例集

各コマンドの具体的なプロンプト例とシナリオ別ワークフロー。

---

## シナリオ別ワークフロー例

### 新機能開発（中規模）

```
# Step 1: 計画
/plan ユーザー認証機能を追加したい。JWT認証でログイン/ログアウト/パスワードリセット

# Step 2: 実装（計画承認後）
/tdd ログインAPIエンドポイントを実装

# Step 3: レビュー
/code-review

# Step 4: 最終検証
/verify pre-pr
```

### 新機能開発（大規模）

```
# 一発で全フロー実行
/orchestrate feature "ダッシュボード機能を追加。ユーザー統計、アクティビティログ、設定画面を含む"
```

### バグ修正

```
# 原因が明確な場合
/tdd ログイン時にセッションが保持されないバグを修正。まず再現テストを書いて

# 原因が不明な場合
/orchestrate bugfix "検索結果が正しく表示されない。特定の条件で空になる"
```

### セキュリティ重視の機能

```
/orchestrate security "決済処理を実装。Stripe連携、クレジットカード情報の取り扱い"
```

### 前回の続き

```
# セッション確認
/sessions list --limit 5

# 読み込み
/sessions load <session-id>

# または エイリアスで
/sessions load my-auth-work
```

---

## コマンド別プロンプト例

### /plan

```
/plan ユーザー認証機能を追加したい。JWT認証でログイン/ログアウト/パスワードリセット

/plan 決済システムをStripeで実装したい。サブスクリプションと単発購入に対応

/plan APIのレスポンス速度を改善したい。現在平均500msかかっている

/plan マイクロサービスに分割したい。現在モノリスで、ユーザー/注文/在庫を分離

/plan GraphQL APIを追加したい。既存のREST APIと並行して運用

/plan キャッシュ層を追加したい。RedisでAPIレスポンスをキャッシュ
```

---

### /orchestrate

```
# 機能開発
/orchestrate feature "ユーザーダッシュボード機能を追加"
/orchestrate feature "リアルタイム通知システムを実装"
/orchestrate feature "ファイルアップロード機能を追加"

# バグ修正
/orchestrate bugfix "ログイン時にセッションが保持されない問題を修正"
/orchestrate bugfix "検索結果のページネーションが正しく動作しない"
/orchestrate bugfix "並行リクエストでデータ不整合が発生する"

# リファクタリング
/orchestrate refactor "認証モジュールをリファクタリング"
/orchestrate refactor "データベースアクセス層をRepository パターンに変更"
/orchestrate refactor "APIエラーハンドリングを統一"

# セキュリティレビュー
/orchestrate security "決済処理周りのセキュリティレビュー"
/orchestrate security "ユーザー認証フローの脆弱性チェック"
/orchestrate security "外部API連携のセキュリティ確認"

# カスタム
/orchestrate custom "planner,tdd-guide,code-reviewer" "新しいAPIエンドポイント追加"
/orchestrate custom "architect,security-reviewer" "インフラ設計レビュー"
```

---

### /tdd

```
# 関数実装
/tdd メールアドレス検証関数を作成して
/tdd パスワード強度チェッカーを実装
/tdd 商品の在庫数を計算する関数
/tdd 日付範囲のバリデーション関数

# APIエンドポイント
/tdd ユーザー登録APIエンドポイントを実装
/tdd 商品検索APIを実装。キーワード、カテゴリ、価格範囲でフィルタ
/tdd ファイルアップロードAPIを実装

# バグ修正（再現テストから）
/tdd ログイン失敗時にエラーメッセージが表示されないバグを修正
/tdd 0円の商品が購入できてしまうバグを修正
```

---

### /go-test

```
/go-test HTTPリクエストのリトライ機能を実装
/go-test JSONパーサーのエラーハンドリング
/go-test 並行処理でファイルを読み込む関数
/go-test データベース接続プールの管理
/go-test 設定ファイルのバリデーション
/go-test gRPCクライアントのタイムアウト処理
```

---

### /build-fix

```
/build-fix
```

※引数なしで実行。自動でビルドエラーを検出・修正。

---

### /go-build

```
/go-build
```

※引数なしで実行。自動でGoビルドエラーを検出・修正。

---

### /code-review

```
/code-review
```

※引数なしで実行。`git diff` で変更ファイルを自動検出してレビュー。

---

### /go-review

```
/go-review
```

※引数なしで実行。Go コードの慣用的パターン、並行処理安全性をレビュー。

---

### /python-review

```
/python-review
```

※引数なしで実行。PEP 8準拠、型ヒント、セキュリティをレビュー。

---

### /verify

```
/verify quick
# ビルド + 型チェックのみ（素早く確認したい時）

/verify
# すべての検証（デフォルト）

/verify pre-commit
# コミット前チェック

/verify pre-pr
# PR前：フル検証 + セキュリティスキャン
```

---

### /test-coverage

```
/test-coverage
```

※引数なしで実行。カバレッジ80%未満のファイルにテストを生成。

---

### /e2e

```
/e2e ログインからダッシュボード表示までのフローをテスト

/e2e 商品をカートに追加して購入完了までのフロー

/e2e ユーザー登録からメール確認までのフロー

/e2e 検索から商品詳細、カート追加、チェックアウトまでの購入フロー

/e2e --headed ログインフローをブラウザで確認
```

---

### /eval

```
/eval define auth-flow
# 認証フローの評価定義を作成

/eval check auth-flow
# 評価を実行

/eval report auth-flow
# 詳細レポートを生成

/eval list
# すべての評価定義を表示
```

---

### /checkpoint

```
/checkpoint create "feature-start"
# 機能開発開始時の状態を保存

/checkpoint create "before-refactor"
# リファクタ前の状態を保存

/checkpoint create "tests-passing"
# テストが通る状態を保存

/checkpoint verify "feature-start"
# 開始時と現在の差分を確認

/checkpoint list
# すべてのチェックポイントを表示

/checkpoint clear
# 古いチェックポイントを削除（最新5個保持）
```

---

### /refactor-clean

```
/refactor-clean
```

※引数なしで実行。デッドコードを検出し、テスト付きで安全に削除。

---

### /learn

```
/learn
```

※引数なしで実行。セッション中に解決した問題からパターンを抽出。

---

### /skill-create

```
/skill-create
# 現在のリポジトリを分析

/skill-create --commits 100
# 直近100コミットを分析

/skill-create --output ./skills --instincts
# スキルと本能を生成
```

---

### /evolve

```
/evolve --dry-run
# プレビューのみ（何が作成されるか確認）

/evolve --execute
# 実際に作成

/evolve --domain testing --execute
# テストドメインのみ進化
```

---

### /instinct-status

```
/instinct-status
# すべての本能を表示

/instinct-status --high-confidence
# 信頼度70%以上のみ

/instinct-status --domain testing
# テストドメインのみ

/instinct-status --low-confidence
# 信頼度が低いもの（改善候補）
```

---

### /instinct-export

```
/instinct-export
# デフォルトファイル名でエクスポート

/instinct-export --output team-instincts.yaml
# ファイル名指定

/instinct-export --domain testing --min-confidence 0.7
# テストドメイン、信頼度70%以上のみ
```

---

### /instinct-import

```
/instinct-import team-instincts.yaml
# ローカルファイルからインポート

/instinct-import https://example.com/instincts.yaml
# URLからインポート

/instinct-import --dry-run team-instincts.yaml
# プレビューのみ（何がインポートされるか確認）
```

---

### /update-docs

```
/update-docs
```

※引数なしで実行。package.json、.env.example からドキュメントを同期。

---

### /update-codemaps

```
/update-codemaps
```

※引数なしで実行。コードベース構造を分析してアーキテクチャドキュメントを更新。

---

### /sessions

```
/sessions list
# セッション一覧

/sessions list --limit 5
# 直近5件

/sessions list --date 2026-02-01
# 特定日付でフィルタ

/sessions list --search "auth"
# 検索

/sessions alias abc123 my-auth-work
# エイリアス作成（覚えやすい名前をつける）

/sessions load my-auth-work
# エイリアスでセッション読み込み

/sessions load abc123
# IDでセッション読み込み

/sessions info my-auth-work
# セッション詳細情報

/sessions aliases
# エイリアス一覧
```

---

### /setup-pm

```
/setup-pm --detect
# 現在のパッケージマネージャーを検出

/setup-pm --global pnpm
# グローバル設定

/setup-pm --project bun
# プロジェクト設定

/setup-pm --list
# 利用可能なパッケージマネージャー一覧
```

---

## よくある質問への回答例

### 「何から始めればいい？」

```
【推奨コマンド】/plan
【プロンプト例】/plan やりたいことを具体的に説明
【次のステップ】計画承認後 → /tdd で実装開始
```

### 「ビルドが通らない」

```
【推奨コマンド】/build-fix（Go: /go-build）
【プロンプト例】/build-fix
【次のステップ】修正後 → /verify quick で確認
```

### 「PRを出したい」

```
【推奨コマンド】/verify pre-pr
【プロンプト例】/verify pre-pr
【次のステップ】PASSなら → PR作成
```

### 「前回の続きをしたい」

```
【推奨コマンド】/sessions
【プロンプト例】/sessions list --limit 5 → /sessions load <id>
【次のステップ】作業再開
```

### 「複雑な機能を一気に作りたい」

```
【推奨コマンド】/orchestrate feature
【プロンプト例】/orchestrate feature "機能の詳細な説明"
【次のステップ】最終レポートを確認 → 必要なら追加修正
```
