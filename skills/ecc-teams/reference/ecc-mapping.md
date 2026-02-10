# ECCコマンド → チームロール対応表

ECCコマンドをAgent Teamsのチームロールにマッピングするリファレンス。

---

## コマンド→ロール対応表

### 計画・設計系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /plan | planner-lead / leader | タスクを分解し、TaskCreateで各メンバーに割り当てる計画を立てる |
| /orchestrate | **Agent Teamsでは使わない** | Agent Teams自体が並列オーケストレーション。/orchestrateはソロ用 |

### 実装系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /tdd | implementer | 各担当モジュールをテスト駆動で実装 |
| /go-test | go-implementer | Go言語モジュールのTDD実装 |
| /build-fix | implementer / fixer | ビルドエラー発生時の修正担当 |
| /go-build | go-implementer | Goビルドエラーの修正 |

### レビュー系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /code-review | reviewer | 他メンバーの実装完了後にコードレビュー |
| /go-review | go-reviewer | Go実装のレビュー担当 |
| /python-review | python-reviewer | Python実装のレビュー担当 |

### 検証系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /verify | verifier / leader | タスク完了時の品質ゲート。leader が最終 /verify pre-pr |
| /test-coverage | tester | カバレッジ分析と不足テスト生成 |
| /e2e | e2e-tester | E2Eテスト専門。UI統合テスト担当 |
| /checkpoint | leader | 並列作業前の安全なロールバックポイント作成 |

### ドキュメント系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /update-docs | doc-writer | 実装と並行してドキュメント更新 |
| /update-codemaps | doc-writer | アーキテクチャ図の更新 |

### 学習系

| ECCコマンド | チームロール | チーム内での使い方 |
|------------|------------|------------------|
| /learn | 全メンバー | セッション終了時に各自実行 |
| /eval | leader / verifier | 機能完成度の評価 |
| /refactor-clean | refactorer | リファクタリング専門担当 |

---

## ソロ→チームワークフロー変換

### 基本変換パターン

**ソロ（順次実行）:**
```
/plan → /tdd → /code-review → /verify pre-pr
```

**チーム（並列実行）:**
```
Leader:  /plan → TaskCreate で分割
           ↓
    ┌──────┴──────┐
impl-1: /tdd     impl-2: /tdd     （並列実装）
    └──────┬──────┘
           ↓
reviewer: /code-review              （レビュー）
           ↓
Leader:  /verify pre-pr             （最終検証）
```

### 変換例: 新機能開発

**ソロ:**
```
/plan 認証機能を実装
/tdd ログインAPI
/tdd パスワードリセット
/code-review
/verify pre-pr
```

**チーム（duo-fullstack）:**
```
Leader:
  1. /plan 認証機能を実装
  2. TaskCreate "ログインAPI" → impl-backend
  3. TaskCreate "ログインUI" → impl-frontend

impl-backend: /tdd ログインAPI
impl-frontend: /tdd ログインUI
  （並列実行）

Leader:
  4. /code-review（全体）
  5. /verify pre-pr
```

### 変換例: バグ修正

**ソロ:**
```
/orchestrate bugfix "検索が動かない"
```

**チーム（bugfix-swarm）:**
```
Leader: TaskCreate で調査タスクを分割

explorer-1: src/search/ を調査
explorer-2: src/api/ を調査
  （並列調査）

Leader: 調査結果を統合、修正タスクを作成

fixer: /tdd で修正
verifier: /verify で検証
```

---

## `/orchestrate` vs Agent Teams 判断表

| 判断基準 | /orchestrate | Agent Teams |
|---------|-------------|-------------|
| 実行方式 | 順次（エージェント間リレー） | 並列（複数Claude Code同時実行） |
| 作業者数 | 1つのClaude Codeインスタンス | 複数のClaude Codeインスタンス |
| 速度 | 直列処理のため遅い | 並列処理で高速 |
| 適用規模 | 中規模（1-2時間） | 大規模（2時間以上） |
| セットアップ | なし | TeamCreate + TaskCreate |
| 推奨場面 | 単一機能、レビューパイプライン | 複数モジュール並列、大規模機能 |

### いつ/orchestrateを使うべきか

- タスクが1つのモジュール内で完結する
- 順番に処理する必要がある（設計→実装→レビュー）
- セットアップの手間を省きたい
- 30分〜2時間程度のタスク

### いつAgent Teamsを使うべきか

- 独立した複数モジュールを同時に実装できる
- フロントエンドとバックエンドを並列で進めたい
- 3つ以上のファイル群を同時に変更する
- 2時間以上かかる大規模タスク
- 実装とレビューを別のエージェントに分担したい

---

## ロール別推奨コマンドセット

### leader（リーダー）
```
/plan → TaskCreate → /verify pre-pr
```
- delegateモードで起動
- タスク分割と最終検証を担当
- 各メンバーの進捗をTaskListで監視

### implementer（実装者）
```
/tdd → /verify quick
```
- 割り当てられたタスクをTDDで実装
- 実装完了時に /verify quick で自己検証
- TaskUpdate で完了報告

### reviewer（レビューアー）
```
/code-review
```
- 実装者のコードをレビュー
- CRITICAL/HIGH の問題を報告
- SendMessage で実装者にフィードバック

### tester（テスター）
```
/test-coverage → /e2e
```
- カバレッジ分析とテスト追加
- E2Eテストの作成・実行

### doc-writer（ドキュメント担当）
```
/update-docs → /update-codemaps
```
- 実装と並行してドキュメント更新
- API仕様、README、コードマップの整備
