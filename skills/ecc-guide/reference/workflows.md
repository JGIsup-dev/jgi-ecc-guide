# ECC ワークフローガイド

開発フェーズ別の推奨コマンドフロー。

---

## 基本ワークフロー

### 新機能開発（標準）

```
/plan → /tdd → /code-review → /verify pre-pr → コミット → PR
```

**各ステップの目的:**
1. `/plan` - 何を作るか明確化、リスク特定
2. `/tdd` - テストファーストで実装
3. `/code-review` - セキュリティと品質チェック
4. `/verify pre-pr` - PR前の最終検証

### 新機能開発（複雑）

```
/orchestrate feature "機能の説明"
```

**内部で実行されるフロー:**
```
planner → tdd-guide → code-reviewer → security-reviewer
```

**使うべき時:**
- 2時間以上かかる機能
- 複数ファイルにまたがる変更
- セキュリティが重要な機能（認証、決済、個人情報）

---

## バグ修正ワークフロー

### 単純なバグ

```
/tdd → /code-review → /verify pre-commit
```

**ポイント:**
- まず失敗するテストを書いて再現
- テストが通るように修正
- レビューで他の問題がないか確認

### 複雑なバグ（原因不明）

```
/orchestrate bugfix "バグの症状"
```

**内部で実行されるフロー:**
```
explorer → tdd-guide → code-reviewer
```

**使うべき時:**
- 原因がわからないバグ
- 複数箇所に影響している可能性がある
- 再現手順が複雑

---

## リファクタリングワークフロー

### デッドコード削除

```
/refactor-clean → /verify
```

**注意:**
- テストが通ることを必ず確認してから削除
- 削除ログが `docs/DELETION_LOG.md` に記録される

### 大規模リファクタリング

```
/orchestrate refactor "リファクタリングの目的"
```

**内部で実行されるフロー:**
```
architect → code-reviewer → tdd-guide
```

**使うべき時:**
- アーキテクチャ変更を伴う
- 複数モジュールに影響
- パフォーマンス改善

---

## 言語別ワークフロー

### Go言語

```
/plan → /go-test → /go-review → /verify pre-pr
```

**ビルドエラー時:**
```
/go-build
```

### Python

```
/plan → /tdd → /python-review → /verify pre-pr
```

### TypeScript/JavaScript

```
/plan → /tdd → /code-review → /verify pre-pr
```

**ビルドエラー時:**
```
/build-fix
```

---

## セッション管理ワークフロー

### 新しいセッション開始時

1. 前回のセッションがあれば確認:
   ```
   /sessions list --limit 5
   ```

2. 続きをする場合:
   ```
   /sessions load <id または alias>
   ```

### セッション終了時

**特別な操作は不要**（Hooksが自動で以下を実行）:
- セッション状態の永続化
- console.log の最終チェック
- パターン評価

**重要なセッションに名前をつける場合:**
```
/sessions alias <session-id> "feature-auth"
```

### 後で続きをしたい場合

**セッション終了前に:**
```
/checkpoint create "作業名"
```

**次回再開時:**
```
/sessions load "feature-auth"
/checkpoint verify "作業名"
```

---

## 学習・改善ワークフロー

### パターン学習

```
/learn → /instinct-status
```

**使うべき時:**
- 複雑な問題を解決した後
- 「これは再利用できそう」と思った時

### チーム共有

```
/instinct-export → チームメンバーに共有 → /instinct-import
```

### Instinctの進化

```
/instinct-status → /evolve
```

**使うべき時:**
- 多くのInstinctが蓄積された時
- 関連パターンをまとめたい時

---

## 検証ワークフロー

### コミット前

```
/verify pre-commit
```

**チェック内容:**
- ビルド
- 型チェック
- リント
- テスト

### PR前

```
/verify pre-pr
```

**チェック内容:**
- 上記すべて + セキュリティスキャン

### クイックチェック

```
/verify quick
```

**チェック内容:**
- ビルド + 型チェックのみ

---

## ドキュメント更新ワークフロー

### コード変更後

```
/update-docs
```

**更新対象:**
- docs/CONTRIB.md（開発ワークフロー）
- docs/RUNBOOK.md（運用手順）

### 構造変更後

```
/update-codemaps
```

**更新対象:**
- codemaps/architecture.md
- codemaps/backend.md
- codemaps/frontend.md
- codemaps/data.md

---

## セキュリティ重視ワークフロー

### 認証・決済・個人情報機能

```
/orchestrate security "機能の説明"
```

**内部で実行されるフロー:**
```
security-reviewer → code-reviewer → architect
```

**チェック項目:**
- OWASP Top 10
- ハードコードされたシークレット
- SQLインジェクション
- XSS
- レースコンディション

---

## 状況別クイックリファレンス

| 状況 | 推奨ワークフロー |
|------|----------------|
| 新機能（30分未満） | `/tdd → /code-review → /verify` |
| 新機能（30分〜2時間） | `/plan → /tdd → /code-review → /verify` |
| 新機能（2時間以上） | `/orchestrate feature "..."` |
| バグ修正（原因明確） | `/tdd → /code-review → /verify` |
| バグ修正（原因不明） | `/orchestrate bugfix "..."` |
| リファクタリング（小） | `/refactor-clean → /verify` |
| リファクタリング（大） | `/orchestrate refactor "..."` |
| セキュリティ重要 | `/orchestrate security "..."` |
| ビルドエラー（TS/JS） | `/build-fix` |
| ビルドエラー（Go） | `/go-build` |
| PR作成前 | `/verify pre-pr` |
| 前回の続き | `/sessions load` |
| 学習保存 | `/learn` |
