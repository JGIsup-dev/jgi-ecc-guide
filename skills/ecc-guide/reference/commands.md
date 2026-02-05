# ECC コマンド完全リファレンス

## Contents

- 開発ワークフロー系（/plan, /tdd, /code-review, /verify）
- ビルド・テスト系（/build-fix, /test-coverage, /e2e）
- Go言語専用（/go-build, /go-test, /go-review）
- 継続学習系（/learn, /instinct-*, /evolve）
- ドキュメント・管理系（/update-docs, /update-codemaps, /checkpoint, /eval）
- その他（/orchestrate, /refactor-clean, /setup-pm, /skill-create, /sessions）

---

## 開発ワークフロー系

### /plan - 実装計画作成
- **用途**: 新機能・リファクタリングの詳細な実装計画を作成
- **いつ使う**: 30分以上かかる作業の前、要件が複雑な時
- **内部動作**: planner エージェントが要件分析→フェーズ分割→リスク評価を実行
- **重要**: 計画のみ作成、コードは書かない。ユーザーが「yes」と回答するまで実装に進まない
- **出力**: フェーズ分けされた計画、依存関係、リスク評価

### /tdd - テスト駆動開発
- **用途**: RED→GREEN→REFACTORサイクルでテストファーストの実装
- **いつ使う**: 新機能実装時、バグ修正時（まず再現テストを書く）
- **内部動作**: tdd-guide エージェントがインターフェース定義→テスト作成→実装→リファクタを指導
- **重要**: 必ずテストを先に書く。実装後にテストを書くのはTDDではない
- **目標**: 80%以上のテストカバレッジ

### /code-review - コードレビュー
- **用途**: セキュリティと品質の観点から未コミット変更をレビュー
- **いつ使う**: 実装完了後、PR作成前
- **内部動作**: code-reviewer エージェントが `git diff` を分析
- **チェック項目**: ハードコードされた認証情報、SQLインジェクション、XSS、大きすぎる関数、エラーハンドリング欠如
- **出力**: CRITICAL/HIGH/MEDIUM/LOW の問題リスト、承認/警告/ブロック判定

### /verify - 包括的検証
- **用途**: コードベース全体の品質検証
- **いつ使う**: コミット前、PR前、デプロイ前
- **サブコマンド**:
  - `/verify` - フル検証
  - `/verify quick` - ビルド + 型チェックのみ
  - `/verify pre-commit` - コミット前チェック
  - `/verify pre-pr` - PR前チェック（セキュリティスキャン含む）
- **チェック項目**: ビルド、型チェック、リント、テスト、console.log監査、Gitステータス

---

## ビルド・テスト系

### /build-fix - ビルドエラー修正
- **用途**: TypeScript/JSのビルドエラーを段階的に修正
- **いつ使う**: `npm run build` が失敗した時
- **内部動作**: build-error-resolver エージェントがエラー解析→修正→再ビルドを繰り返す
- **停止条件**: 同じエラーが3回修正できない、新たなエラーが発生
- **重要**: 最小限の変更のみ、アーキテクチャ変更は行わない

### /test-coverage - テストカバレッジ分析
- **用途**: カバレッジ分析と不足テスト生成
- **いつ使う**: カバレッジが80%未満の時、テスト追加時
- **動作**: `npm test --coverage` 実行→80%未満ファイル特定→テスト生成

### /e2e - E2Eテスト生成・実行
- **用途**: Playwrightを使用したE2Eテスト
- **いつ使う**: 重要なユーザーフローのテスト、UI実装完了後
- **内部動作**: e2e-runner エージェントがPage Object Modelでテスト生成
- **出力**: 複数ブラウザでのテスト結果、スクリーンショット、動画、トレース

---

## Go言語専用

### /go-build - Goビルドエラー修正
- **用途**: `go build`、`go vet`、リンターエラーの修正
- **いつ使う**: Goビルドが失敗した時
- **内部動作**: go-build-resolver エージェントが診断→修正→再ビルド
- **よくあるエラー**: undefined識別子、型不一致、インポートサイクル

### /go-test - Go TDDワークフロー
- **用途**: Goでのテスト駆動開発
- **いつ使う**: Go新機能実装時
- **特徴**: テーブル駆動テストパターンを使用

### /go-review - Goコードレビュー
- **用途**: Go特有のベストプラクティス観点でのレビュー
- **いつ使う**: Go実装完了後、PR前
- **内部動作**: go-reviewer エージェントが `go vet`、`staticcheck` も実行
- **チェック項目**: エラーハンドリング、goroutineリーク、レースコンディション、Goイディオム

---

## 継続学習系

### /learn - パターン抽出
- **用途**: 現在のセッションから再利用可能なパターンを抽出
- **いつ使う**: 複雑な問題を解決した後、繰り返し使えそうなパターン発見時
- **抽出対象**: エラー解決パターン、デバッグテクニック、回避策、プロジェクト固有パターン

### /instinct-status - Instinctステータス確認
- **用途**: 学習したInstinct（本能）一覧と信頼度スコア表示
- **いつ使う**: 学習状況を確認したい時
- **Instinctとは**: Skillsより細かい粒度の原子的行動単位、信頼度スコア（0.3〜0.9）付き

### /instinct-export - Instinctエクスポート
- **用途**: InstinctをYAML形式でエクスポート
- **いつ使う**: チーム共有時、バックアップ時、新マシン移行時

### /instinct-import - Instinctインポート
- **用途**: 外部からInstinctをインポート
- **いつ使う**: チームメイトのInstinct取り込み、共有規約適用時

### /evolve - Instinctの進化
- **用途**: 関連Instinctをクラスタリングして Skills/Commands/Agents に進化
- **いつ使う**: 多くのInstinctが蓄積された時
- **進化ルール**:
  - Command: ユーザーが明示的に呼び出すアクション
  - Skill: 自動トリガーされる行動
  - Agent: 複雑な多段階プロセス

---

## ドキュメント・管理系

### /update-docs - ドキュメント更新
- **用途**: ソースコードからドキュメント自動生成・更新
- **いつ使う**: コード変更後、スクリプト追加後、環境変数追加後
- **内部動作**: doc-updater エージェントが package.json、.env.example を解析
- **生成**: docs/CONTRIB.md、docs/RUNBOOK.md

### /update-codemaps - コードマップ更新
- **用途**: コードベース構造のアーキテクチャドキュメント更新
- **いつ使う**: 大規模リファクタリング後、新メンバー参加時
- **生成**: codemaps/architecture.md、backend.md、frontend.md、data.md

### /checkpoint - チェックポイント管理
- **用途**: ワークフロー中の状態保存・検証
- **いつ使う**: 重要なマイルストーン到達時、安全なロールバックポイント作成時
- **サブコマンド**:
  - `/checkpoint create <name>` - チェックポイント作成
  - `/checkpoint verify <name>` - 現在状態と比較
  - `/checkpoint list` - 一覧表示
  - `/checkpoint clear` - 古いものを削除（最新5個保持）

### /eval - 評価駆動開発
- **用途**: 機能の完成度測定、リグレッション防止
- **いつ使う**: 機能完成度を測りたい時、PR準備状況確認時
- **サブコマンド**:
  - `/eval define <name>` - 評価定義
  - `/eval check <name>` - 評価実行
  - `/eval report <name>` - レポート生成

---

## その他

### /orchestrate - エージェントオーケストレーション
- **用途**: 複雑なタスクに対して複数エージェントを順序実行
- **いつ使う**: 大規模機能実装、複数観点からのレビューが必要な時
- **ワークフロータイプ**:
  - `feature`: planner → tdd-guide → code-reviewer → security-reviewer
  - `bugfix`: explorer → tdd-guide → code-reviewer
  - `refactor`: architect → code-reviewer → tdd-guide
  - `security`: security-reviewer → code-reviewer → architect
  - `custom`: 任意のエージェント指定
- **使用例**:
  - `/orchestrate feature "ユーザー認証を追加"`
  - `/orchestrate bugfix "検索が機能しない"`
  - `/orchestrate custom "architect,tdd-guide" "キャッシュ再設計"`
- **出力**: 最終レポート（SHIP / NEEDS WORK / BLOCKED 判定）

### /refactor-clean - デッドコード削除
- **用途**: 未使用コード・依存関係の安全な削除
- **いつ使う**: コードベースクリーンアップ時、バンドルサイズ削減時
- **内部動作**: refactor-cleaner エージェントが knip、depcheck、ts-prune を使用
- **重要**: テスト実行なしにコード削除は絶対にしない

### /setup-pm - パッケージマネージャー設定
- **用途**: プロジェクト/グローバルのパッケージマネージャー設定
- **いつ使う**: プロジェクト初期化時、チーム統一時
- **検出優先順位**: 環境変数 → プロジェクト設定 → package.json → ロックファイル

### /skill-create - ローカルスキル生成
- **用途**: Git履歴からコーディングパターンを抽出しSKILL.mdを生成
- **いつ使う**: プロジェクト規約をスキル化したい時、新メンバーへの共有時

### /sessions - セッション管理
- **用途**: 過去セッションの一覧・読み込み・エイリアス管理
- **サブコマンド**:
  - `/sessions list` - セッション一覧
  - `/sessions list --limit 10` - 最大10件
  - `/sessions list --date 2026-02-01` - 日付フィルタ
  - `/sessions load <id|alias>` - セッション読み込み
  - `/sessions alias <id> <name>` - エイリアス作成
  - `/sessions info <id|alias>` - 詳細情報
  - `/sessions aliases` - エイリアス一覧

---

## 内部エージェント知識

コマンドの裏で動く専門家エージェント（ユーザーには見えない）。

| カテゴリ | エージェント | 担当コマンド/役割 |
|---------|-------------|------------------|
| 設計・計画 | architect | システム設計、アーキテクチャ判断 |
| 設計・計画 | planner | /plan、実装計画立案 |
| 設計・計画 | doc-updater | /update-docs、/update-codemaps |
| 品質保証 | code-reviewer | /code-review |
| 品質保証 | security-reviewer | セキュリティ脆弱性検出（/orchestrate security） |
| 品質保証 | database-reviewer | DB最適化、RLS |
| テスト | tdd-guide | /tdd、TDD指導 |
| テスト | e2e-runner | /e2e |
| 保守 | build-error-resolver | /build-fix |
| 保守 | refactor-cleaner | /refactor-clean |
| Go専用 | go-reviewer | /go-review |
| Go専用 | go-build-resolver | /go-build |

---

## Hooks システム

ユーザーが意識しなくても自動で実行される処理。

### ツール実行前（PreToolUse）
- tmuxリマインダー: 長時間コマンド実行時にtmux使用を推奨
- git pushレビュー: push前に変更内容のレビュー確認
- 不要ファイルブロック: 無駄な.md/.txtファイル作成を防止

### ツール実行後（PostToolUse）
- Prettier自動フォーマット: .ts/.tsx/.js/.jsx編集後に自動フォーマット
- TypeScript型チェック: .ts/.tsx編集後に `tsc --noEmit` 実行
- console.log警告: 編集ファイル内のconsole.log検出・警告

### セッション開始/終了時
- 開始: 前回コンテキストの読み込み、パッケージマネージャー検出
- 終了: セッション状態の永続化、console.log最終チェック、パターン評価
