# /team - Agent Teamsナビゲーター

## 概要

Agent Teamsを使った**並列開発チーム構成**のガイド。
「どのチーム構成で並列開発するか」を推奨し、セットアップ手順と注意事項を提示する。

`/guide`が「どのECCコマンドを使うか」をナビゲートするように、
`/team`は「どのチーム構成で並列開発するか」をナビゲートする。

## 知識ベース

このガイドは以下を完全に理解している：
- Agent Teams（TeamCreate, TaskCreate, SendMessage等）の仕組み
- 8つのチーム構成テンプレート
- ECCコマンドとチームロールの対応
- タスク依存パターン（パイプライン、ファンアウト、ファンイン、ダイアモンド）
- 通信パターン（DM, broadcast, shutdown）
- tmux等の表示モード

## 厳格なルール

1. このコマンドは **チーム構成の推奨のみ** を行う
2. TeamCreateやTaskCreateを実行しない、コードを書かない
3. 必ず【推奨チーム構成】【チームメンバー】【セットアップ手順】【注意事項】【完了後】の形式で回答する
4. 推奨するのは8つの定義済み構成から選択（または組み合わせ）
5. 単純なタスクには「チーム不要」と判断し、`/guide`に誘導する
6. ECCコマンドとロールの対応を明示する

## 使用方法

```
/team 〇〇をチームで開発したい
```

## 出力形式

必ず以下の形式で回答する：

```
【推奨チーム構成】構成名

【チームメンバー】
- リーダー（自分）: delegate モードで調整役 - /plan, /verify
- メンバー1: 役割 - 使用するECCコマンド
- メンバー2: 役割 - 使用するECCコマンド

【セットアップ手順】
1. TeamCreate で "チーム名" を作成
2. /plan でタスクを分解
3. TaskCreate で具体的なタスクを定義
4. Task tool で各メンバーをスポーン（team_name指定）

【注意事項】
- 注意すべき点

【完了後】
1. /verify pre-pr で最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### チーム不要の場合の出力形式

```
【判断】チーム不要

このタスクはソロ作業の方が効率的です。

【推奨】
/guide 〇〇したい

で最適なECCコマンドを確認してください。

【理由】
- チームが不要な理由
```

---

## 判断ロジック

### 軸1: 複雑さ

| レベル | シグナル | 判断 |
|-------|---------|------|
| 単純（30分未満） | 「ちょっとした」「簡単な」「小さな修正」 | チーム不要→`/guide`に誘導 |
| 中程度（30分〜2時間） | 「機能追加」「実装したい」 | 2エージェント（duo系） |
| 複雑（2時間超） | 「大規模」「複数機能」「全体的に」 | 3-4エージェント（squad/architecture） |
| 超複雑 | 「アーキテクチャ」「マイクロサービス」「フレームワーク移行」 | 4-5エージェント（architecture/sprint） |

### 軸2: 並列化パターン

| パターン | シグナル | 構成 |
|---------|---------|------|
| 独立モジュール | 「フロントとバック」「UI+API」 | duo-fullstack / squad-feature |
| パイプライン | 「計画→実装→テスト」 | architecture-team |
| レビュー重視 | 「セキュリティ」「品質」「監査」 | review-panel |
| フルライフサイクル | 「一気に全部」「スプリント」 | sprint-team |
| バグ修正 | 「原因不明」「複雑なバグ」 | bugfix-swarm |
| テスト強化 | 「カバレッジ」「テスト追加」 | tdd-factory |

---

## 状況→構成マッピング

### 1. フルスタック機能開発

**シグナル**: 「フロントエンドとバックエンドを同時に」「UIとAPIを並列で」

```
【推奨チーム構成】duo-fullstack

【チームメンバー】
- リーダー（自分）: delegate モードで計画・調整・最終検証 - /plan, /verify pre-pr
- impl-frontend: フロントエンド実装 - /tdd, /e2e
- impl-backend: バックエンド実装 - /tdd, /test-coverage

【セットアップ手順】
1. TeamCreate で "feature-名前" を作成
2. /plan でAPI仕様を確定（フロント・バック間のインターフェース定義）
3. TaskCreate "API仕様確定" → リーダー
4. TaskCreate "バックエンドAPI実装" → impl-backend (blockedBy: API仕様)
5. TaskCreate "フロントエンドUI実装" → impl-frontend (blockedBy: API仕様)
6. TaskCreate "統合テスト" → リーダー (blockedBy: バックエンド, フロントエンド)
7. Task tool で impl-frontend と impl-backend をスポーン

【注意事項】
- API仕様（型定義・エンドポイント）を先に確定してから並列作業を開始すること
- フロント・バック間の仕様変更が発生したらbroadcastで全員に通知

【完了後】
1. /verify pre-pr で最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### 2. 大規模機能開発

**シグナル**: 「大規模な機能」「複数のモジュール」「半日以上かかる」

```
【推奨チーム構成】squad-feature

【チームメンバー】
- リーダー（自分）: delegate モードで計画・統合 - /plan, /verify pre-pr
- impl-1: モジュールA実装 - /tdd
- impl-2: モジュールB実装 - /tdd
- reviewer: コードレビュー - /code-review

【セットアップ手順】
1. TeamCreate で "feature-名前" を作成
2. /plan で機能を独立モジュールに分割
3. TaskCreate で各モジュールの実装タスクとレビュータスクを定義
4. タスク間の依存関係を addBlockedBy で設定
5. Task tool で各メンバーをスポーン

【注意事項】
- モジュール分割は依存関係を最小化するように設計
- 共通の型定義やインターフェースはリーダーが先に作成
- reviewerは各モジュール完了後に順次レビュー

【完了後】
1. /verify pre-pr で最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### 3. バグ調査チーム

**シグナル**: 「原因不明のバグ」「複雑なバグ」「調査が必要」

```
【推奨チーム構成】bugfix-swarm

【チームメンバー】
- リーダー（自分）: delegate モードで調査統合・方針決定 - /plan
- explorer: コードベース調査 - 調査・分析
- fixer: バグ修正実装 - /tdd

【セットアップ手順】
1. TeamCreate で "bugfix-名前" を作成
2. TaskCreate "バグ再現・範囲特定" → explorer
3. TaskCreate "根本原因分析" → explorer (blockedBy: 再現)
4. TaskCreate "修正方針決定" → リーダー (blockedBy: 原因分析)
5. TaskCreate "バグ修正" → fixer (blockedBy: 方針決定)
6. TaskCreate "修正検証" → リーダー (blockedBy: 修正)
7. Task tool で explorer と fixer をスポーン

【注意事項】
- explorerの調査結果を待ってから修正方針を決定
- 修正は最小限の変更に留める
- 再現テストを必ず先に作成

【完了後】
1. /verify pre-pr で最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### 4. セキュリティ監査

**シグナル**: 「セキュリティ」「監査」「脆弱性」「認証」「決済」

```
【推奨チーム構成】review-panel

【チームメンバー】
- リーダー（自分）: delegate モードでレビュー統合 - /verify pre-pr
- code-reviewer: コード品質レビュー - /code-review
- security-reviewer: セキュリティ観点レビュー - セキュリティパターン適用

【セットアップ手順】
1. TeamCreate で "review-名前" を作成
2. TaskCreate "コード品質レビュー" → code-reviewer
3. TaskCreate "セキュリティレビュー" → security-reviewer
4. TaskCreate "レビュー統合・修正指示" → リーダー (blockedBy: 両レビュー)
5. Task tool で各レビューアーをスポーン

【注意事項】
- 各レビューアーは独立して並列にレビュー可能
- CRITICAL/HIGHの指摘は全て修正必須
- セキュリティレビューではOWASP Top 10を網羅

【完了後】
1. 全指摘事項の修正確認
2. /verify pre-pr で最終検証
3. SendMessage (shutdown_request) で全メンバーを終了
4. TeamDelete でクリーンアップ
```

### 5. リファクタリング

**シグナル**: 「アーキテクチャ変更」「大規模リファクタ」「構造変更」

```
【推奨チーム構成】architecture-team

【チームメンバー】
- リーダー（自分）: delegate モードで設計方針・調整 - /plan
- architect: 設計・構造提案 - /plan, /refactor-clean
- impl: 変更実装 - /tdd
- tester: テスト更新・検証 - /test-coverage, /verify

【セットアップ手順】
1. /checkpoint create "before-refactor" でセーフポイント作成
2. TeamCreate で "refactor-名前" を作成
3. TaskCreate "現状分析・設計提案" → architect
4. TaskCreate "設計レビュー" → リーダー (blockedBy: 分析)
5. TaskCreate "構造変更実装" → impl (blockedBy: レビュー)
6. TaskCreate "テスト更新" → tester (blockedBy: 実装)
7. Task tool で各メンバーをスポーン

【注意事項】
- 必ずチェックポイントを作成してからリファクタリング開始
- 設計提案はリーダーが承認してから実装に移る
- テストが通ることを各ステップで確認

【完了後】
1. /verify pre-pr で最終検証
2. /checkpoint verify "before-refactor" で差分確認
3. SendMessage (shutdown_request) で全メンバーを終了
4. TeamDelete でクリーンアップ
```

### 6. テスト強化

**シグナル**: 「テストカバレッジ」「テスト追加」「テスト戦略」

```
【推奨チーム構成】tdd-factory

【チームメンバー】
- リーダー（自分）: delegate モードでテスト戦略・調整 - /test-coverage, /verify
- unit-tester: ユニットテスト - /tdd
- integration-tester: 統合テスト - /tdd

【セットアップ手順】
1. TeamCreate で "testing-名前" を作成
2. /test-coverage でカバレッジ分析
3. TaskCreate "ユニットテスト: moduleA" → unit-tester
4. TaskCreate "ユニットテスト: moduleB" → unit-tester
5. TaskCreate "統合テスト作成" → integration-tester
6. TaskCreate "カバレッジ確認" → リーダー (blockedBy: 全テスト)
7. Task tool で各テスターをスポーン

【注意事項】
- まずカバレッジ分析で優先度の高いファイルを特定
- テスト同士の依存を避ける（各テストは独立）
- 既存テストを壊さないよう注意

【完了後】
1. /test-coverage でカバレッジ再確認（80%以上が目標）
2. /verify pre-pr で最終検証
3. SendMessage (shutdown_request) で全メンバーを終了
4. TeamDelete でクリーンアップ
```

### 7. PR準備（実装+ドキュメント）

**シグナル**: 「ドキュメントも一緒に」「実装とドキュメントを同時に」

```
【推奨チーム構成】docs-and-code

【チームメンバー】
- リーダー（自分）: delegate モードで調整・最終確認 - /verify pre-pr
- impl: 機能実装 - /tdd, /code-review
- doc-writer: ドキュメント作成 - /update-docs, /update-codemaps

【セットアップ手順】
1. TeamCreate で "feature-名前" を作成
2. TaskCreate "機能実装" → impl
3. TaskCreate "API仕様書作成" → doc-writer
4. TaskCreate "README更新" → doc-writer (blockedBy: 実装)
5. TaskCreate "最終確認" → リーダー (blockedBy: 実装, ドキュメント)
6. Task tool で impl と doc-writer をスポーン

【注意事項】
- doc-writerはAPI仕様書など実装に依存しない部分から先に着手
- 実装完了後にREADMEやCHANGELOGを更新

【完了後】
1. /verify pre-pr で最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### 8. レビュー集中

**シグナル**: 「レビューを複数観点で」「品質チェック」

→ 構成4（セキュリティ監査）の `review-panel` と同じ。
パフォーマンスレビューアーを追加する場合は3名構成に。

### 9. プロトタイプ

**シグナル**: 「プロトタイプ」「PoC」「検証用」

```
【推奨チーム構成】duo-fullstack（簡易版）

【チームメンバー】
- リーダー（自分）: アクティブモードで自分も実装 - /plan, /tdd
- impl: もう一方の領域を実装 - /tdd

【セットアップ手順】
1. TeamCreate で "proto-名前" を作成
2. /plan で最小限の機能を定義
3. TaskCreate でタスクを2分割
4. Task tool で impl をスポーン

【注意事項】
- プロトタイプなのでレビューは省略可
- 最小限の機能に集中
- テストは主要パスのみでOK

【完了後】
1. /verify quick で簡易検証
2. SendMessage (shutdown_request) でメンバーを終了
3. TeamDelete でクリーンアップ
```

### 10. DB移行

**シグナル**: 「データベース移行」「スキーマ変更」「マイグレーション」

→ 構成5（リファクタリング）の `architecture-team` を使用。
architectロールにDB設計を担当させる。

### 11. スプリント消化

**シグナル**: 「スプリント」「バックログ」「複数タスクを一気に」

```
【推奨チーム構成】sprint-team

【チームメンバー】
- リーダー（自分）: delegate モードでタスク管理 - /plan, /verify pre-pr
- worker-1: タスクA担当 - /plan, /tdd, /verify quick
- worker-2: タスクB担当 - /plan, /tdd, /verify quick
- worker-3: タスクC担当 - /plan, /tdd, /verify quick

【セットアップ手順】
1. TeamCreate で "sprint-名前" を作成
2. /plan でバックログの各タスクを整理
3. TaskCreate で各workerにタスクを割り当て
4. タスク間の依存関係がある場合は addBlockedBy で設定
5. Task tool で各workerをスポーン

【注意事項】
- 各タスクが本当に独立していることを確認
- 同じファイルを複数workerが編集しないよう分割
- 各workerは完了前に /verify quick を実行

【完了後】
1. /verify pre-pr で全体の最終検証
2. SendMessage (shutdown_request) で全メンバーを終了
3. TeamDelete でクリーンアップ
```

### 12. 複数の独立タスク

**シグナル**: 「これとこれとこれをやって」「別々のタスクを同時に」

→ 構成11（スプリント消化）の `sprint-team` と同じ。

---

## `/guide`との使い分け

| 判断基準 | /guide | /team |
|---------|--------|-------|
| 作業者数 | 1人（順次実行） | 複数（並行実行） |
| 適用範囲 | 単純〜複雑 | 複雑〜超複雑 |
| 所要時間 | 30分〜2時間 | 2時間以上 |
| /orchestrate | 十分 | 不足（並列化必要） |
| セットアップ | 不要 | TeamCreate + TaskCreate |

### 判断フロー

```
タスクを受け取る
  ↓
30分未満? → /guide に誘導
  ↓
並列化可能? → No → /guide に誘導（/orchestrate推奨）
  ↓ Yes
2つ以上の独立モジュール? → Yes → /team で構成推奨
  ↓ No
並列化メリット < セットアップコスト? → Yes → /guide に誘導
  ↓ No
/team で構成推奨
```

---

## 単純タスクへの対応

**シグナル**: 「ちょっとした修正」「小さなバグ」「1ファイルだけ」

```
【判断】チーム不要

このタスクはソロ作業の方が効率的です。

【推奨】
/guide 〇〇したい

で最適なECCコマンドを確認してください。

【理由】
- タスクが小さく、チームのセットアップコストが作業時間を上回る
- 並列化可能なモジュール分割がない
- /orchestrate または 直接 /tdd で十分対応可能
```

---

## Related Skills

This command references the `ecc-teams` skill.

The skill structure:
```
skills/ecc-teams/
├── SKILL.md                       # 概要とクイックリファレンス
└── reference/
    ├── configurations.md          # 8つのチーム構成テンプレート
    ├── patterns.md                # 調整パターン・ベストプラクティス
    └── ecc-mapping.md             # ECCコマンド→チームロール対応表
```

For detailed information:
- **チーム構成**: See [../skills/ecc-teams/reference/configurations.md](../skills/ecc-teams/reference/configurations.md)
- **調整パターン**: See [../skills/ecc-teams/reference/patterns.md](../skills/ecc-teams/reference/patterns.md)
- **ECC対応表**: See [../skills/ecc-teams/reference/ecc-mapping.md](../skills/ecc-teams/reference/ecc-mapping.md)
