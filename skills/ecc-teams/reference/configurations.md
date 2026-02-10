# Agent Teams チーム構成テンプレート

8つの定義済みチーム構成。プロジェクトの状況に応じて選択する。

---

## 1. `duo-fullstack` - フロントエンド+バックエンド並列

**チームサイズ**: 2名
**用途**: フロントエンドとバックエンドを同時に開発

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 計画・調整・最終検証 | /plan, /verify pre-pr |
| impl-frontend | default | フロントエンド実装 | /tdd, /e2e |
| impl-backend | default | バックエンド実装 | /tdd, /test-coverage |

### タスク依存関係の例

```
TaskCreate "API設計を確定" → leader
TaskCreate "バックエンドAPI実装" → impl-backend (blockedBy: API設計)
TaskCreate "フロントエンドUI実装" → impl-frontend (blockedBy: API設計)
TaskCreate "統合テスト" → leader (blockedBy: バックエンド, フロントエンド)
```

### 使うべき場面

- 新機能にUIとAPIの両方が必要
- フロントとバックで明確に分離できる
- 2時間〜半日程度のタスク

### 避けるべき場面

- フロントとバックの依存が強く、頻繁に仕様調整が必要
- どちらか一方だけの変更で済む

---

## 2. `squad-feature` - 大規模機能分割チーム

**チームサイズ**: 3-4名
**用途**: 大規模な機能を分割して並列実装

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 計画・タスク分割・統合 | /plan, /verify pre-pr |
| impl-1 | default | モジュールA実装 | /tdd |
| impl-2 | default | モジュールB実装 | /tdd |
| reviewer | default | コードレビュー | /code-review |

### タスク依存関係の例

```
TaskCreate "機能設計・タスク分割" → leader
TaskCreate "モジュールA実装" → impl-1 (blockedBy: 設計)
TaskCreate "モジュールB実装" → impl-2 (blockedBy: 設計)
TaskCreate "モジュールAレビュー" → reviewer (blockedBy: モジュールA)
TaskCreate "モジュールBレビュー" → reviewer (blockedBy: モジュールB)
TaskCreate "統合・最終検証" → leader (blockedBy: レビュー完了)
```

### 使うべき場面

- 半日以上かかる大規模機能
- 3つ以上の独立したモジュールに分割可能
- 品質重視でレビューを別担当にしたい

### 避けるべき場面

- モジュール間の依存が複雑
- 2時間未満で終わるタスク

---

## 3. `review-panel` - 多角的レビューチーム

**チームサイズ**: 2-3名
**用途**: 複数の観点からコードをレビュー

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 調整・レビュー統合 | /verify pre-pr |
| code-reviewer | default | コード品質レビュー | /code-review |
| security-reviewer | default | セキュリティレビュー | セキュリティ観点でレビュー |
| perf-reviewer (任意) | default | パフォーマンスレビュー | パフォーマンス観点でレビュー |

### タスク依存関係の例

```
TaskCreate "コード品質レビュー" → code-reviewer
TaskCreate "セキュリティレビュー" → security-reviewer
TaskCreate "パフォーマンスレビュー" → perf-reviewer
TaskCreate "レビュー統合・修正指示" → leader (blockedBy: 全レビュー)
```

### 使うべき場面

- セキュリティが重要な機能（認証、決済、個人情報）
- パフォーマンスクリティカルな部分
- PR前の最終レビュー

### 避けるべき場面

- 小規模な変更
- 内部ツールなどセキュリティ要件が低い

---

## 4. `tdd-factory` - テスト集中チーム

**チームサイズ**: 2-3名
**用途**: テストカバレッジ向上・テスト戦略実行

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | テスト戦略・調整 | /test-coverage, /verify |
| unit-tester | default | ユニットテスト | /tdd |
| integration-tester | default | 統合テスト | /tdd |
| e2e-tester (任意) | default | E2Eテスト | /e2e |

### タスク依存関係の例

```
TaskCreate "カバレッジ分析" → leader
TaskCreate "ユニットテスト: moduleA" → unit-tester (blockedBy: 分析)
TaskCreate "ユニットテスト: moduleB" → unit-tester (blockedBy: 分析)
TaskCreate "統合テスト作成" → integration-tester (blockedBy: 分析)
TaskCreate "E2Eテスト作成" → e2e-tester (blockedBy: 分析)
TaskCreate "カバレッジ確認" → leader (blockedBy: 全テスト)
```

### 使うべき場面

- テストカバレッジ80%未満のプロジェクト
- テスト戦略の大幅な見直し
- リリース前のテスト強化

### 避けるべき場面

- すでにカバレッジが十分（80%以上）
- 新機能実装が優先の場面

---

## 5. `bugfix-swarm` - バグ調査修正チーム

**チームサイズ**: 2-3名
**用途**: 複雑なバグの調査と修正

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 調査統合・方針決定 | /plan |
| explorer | default | コードベース調査 | 調査・分析 |
| fixer | default | バグ修正実装 | /tdd |
| verifier (任意) | default | 修正検証 | /verify, /e2e |

### タスク依存関係の例

```
TaskCreate "バグ再現・範囲特定" → explorer
TaskCreate "根本原因分析" → explorer (blockedBy: 再現)
TaskCreate "修正方針決定" → leader (blockedBy: 原因分析)
TaskCreate "バグ修正実装" → fixer (blockedBy: 方針決定)
TaskCreate "修正検証" → verifier (blockedBy: 修正実装)
```

### 使うべき場面

- 原因不明の複雑なバグ
- 複数箇所に影響している可能性がある
- 再現手順が複雑

### 避けるべき場面

- 原因が明確な単純バグ（ソロで/tddが効率的）
- UIの見た目の問題

---

## 6. `architecture-team` - 設計変更チーム

**チームサイズ**: 3-4名
**用途**: アーキテクチャ変更・大規模リファクタリング

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 設計方針・調整 | /plan |
| architect | default | 設計・構造変更 | /plan, /refactor-clean |
| impl | default | 変更実装 | /tdd |
| tester | default | テスト・検証 | /test-coverage, /verify |

### タスク依存関係の例

```
TaskCreate "現状分析・設計提案" → architect
TaskCreate "設計レビュー・承認" → leader (blockedBy: 設計)
TaskCreate "構造変更実装" → impl (blockedBy: 承認)
TaskCreate "テスト更新・追加" → tester (blockedBy: 実装)
TaskCreate "最終検証" → leader (blockedBy: テスト)
```

### 使うべき場面

- アーキテクチャの根本的な変更
- マイクロサービス分割
- データベーススキーマの大幅変更
- フレームワーク移行

### 避けるべき場面

- 小規模なリファクタリング（/refactor-cleanで十分）
- 既存アーキテクチャ内での機能追加

---

## 7. `sprint-team` - スプリント並列消化チーム

**チームサイズ**: 3-5名
**用途**: 複数の独立タスクを並列消化

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | タスク管理・品質管理 | /plan, /verify pre-pr |
| worker-1 | default | タスクA | /plan, /tdd, /verify quick |
| worker-2 | default | タスクB | /plan, /tdd, /verify quick |
| worker-3 | default | タスクC | /plan, /tdd, /verify quick |
| worker-4 (任意) | default | タスクD | /plan, /tdd, /verify quick |

### タスク依存関係の例

```
TaskCreate "タスクA: ユーザー設定画面" → worker-1
TaskCreate "タスクB: 通知機能" → worker-2
TaskCreate "タスクC: 検索改善" → worker-3
TaskCreate "全体統合テスト" → leader (blockedBy: A, B, C)
TaskCreate "最終検証" → leader (blockedBy: 統合テスト)
```

### 使うべき場面

- スプリントバックログの並列消化
- 互いに独立した複数のタスク
- 締め切りが近い複数タスク

### 避けるべき場面

- タスク間の依存が強い
- 1-2個のタスクしかない

---

## 8. `docs-and-code` - 実装+ドキュメント並行チーム

**チームサイズ**: 2名
**用途**: 実装とドキュメントを同時進行

### ロール構成

| ロール | モード | 担当 | 使用ECCコマンド |
|--------|-------|------|----------------|
| leader (自分) | delegate | 調整・最終確認 | /verify pre-pr |
| impl | default | 機能実装 | /tdd, /code-review |
| doc-writer | default | ドキュメント作成 | /update-docs, /update-codemaps |

### タスク依存関係の例

```
TaskCreate "機能実装" → impl
TaskCreate "API仕様書作成" → doc-writer
TaskCreate "README更新" → doc-writer (blockedBy: 実装完了)
TaskCreate "最終確認" → leader (blockedBy: 実装, ドキュメント)
```

### 使うべき場面

- ドキュメント必須の機能（外部API、ライブラリ）
- オープンソースプロジェクト
- チーム間共有が必要な機能

### 避けるべき場面

- 内部ツール
- プロトタイプ段階

---

## 構成選択ガイド

| やりたいこと | 推奨構成 |
|-------------|---------|
| フロントとバックを同時に作りたい | `duo-fullstack` |
| 大きな機能を分割して並列開発 | `squad-feature` |
| セキュリティ含む多角レビュー | `review-panel` |
| テストカバレッジを一気に上げたい | `tdd-factory` |
| 複雑なバグを複数人で調査・修正 | `bugfix-swarm` |
| アーキテクチャを変更したい | `architecture-team` |
| 複数の独立タスクを一気に消化 | `sprint-team` |
| 実装とドキュメントを同時に | `docs-and-code` |
