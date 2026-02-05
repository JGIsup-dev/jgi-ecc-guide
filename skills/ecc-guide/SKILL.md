---
name: ecc-guide
description: Use this skill when users ask which ECC command to use, need guidance on development workflows, or want to understand how to use everything-claude-code effectively. Provides complete knowledge of all 24 commands, 12 agents, hooks, sessions, and recommended workflows.
---

# ECC Guide

everything-claude-code（ECC）のナビゲーションガイド。

## When to Activate

- ユーザーが「どのコマンドを使えばいい？」と聞いた時
- ユーザーが「次に何をすればいい？」と聞いた時
- ユーザーがECCのワークフローについて質問した時
- ユーザーがセッション管理について質問した時
- ユーザーが迷っている・わからないと言った時

## Reference Files

**コマンド詳細**: See [reference/commands.md](reference/commands.md) for complete command reference
**ワークフロー**: See [reference/workflows.md](reference/workflows.md) for development phase workflows
**プロンプト例**: See [reference/prompts.md](reference/prompts.md) for concrete prompt examples

## Quick Reference

### コマンド一覧（24個）

| カテゴリ | コマンド | 用途 |
|---------|---------|------|
| 計画 | /plan | 実装計画作成 |
| 計画 | /orchestrate | 複数エージェント連携 |
| 実装 | /tdd | テスト駆動開発 |
| 実装 | /go-test | Go TDD |
| ビルド | /build-fix | TS/JSビルド修正 |
| ビルド | /go-build | Goビルド修正 |
| レビュー | /code-review | コードレビュー |
| レビュー | /go-review | Goレビュー |
| レビュー | /python-review | Pythonレビュー |
| 検証 | /verify | 包括的検証 |
| 検証 | /test-coverage | カバレッジ分析 |
| 検証 | /e2e | E2Eテスト |
| 検証 | /eval | 評価管理 |
| 検証 | /checkpoint | 状態保存 |
| リファクタ | /refactor-clean | デッドコード削除 |
| 学習 | /learn | パターン抽出 |
| 学習 | /skill-create | スキル生成 |
| 学習 | /evolve | 本能進化 |
| 学習 | /instinct-status | 本能確認 |
| 学習 | /instinct-export | 本能エクスポート |
| 学習 | /instinct-import | 本能インポート |
| ドキュメント | /update-docs | ドキュメント更新 |
| ドキュメント | /update-codemaps | コードマップ更新 |
| 管理 | /sessions | セッション管理 |
| 管理 | /setup-pm | パッケージマネージャー設定 |

## 推奨判断基準

### 複雑さによる判断

| 複雑さ | 推奨アプローチ |
|-------|--------------|
| 単純（30分未満） | 直接 /tdd で実装開始 |
| 中程度（30分〜2時間） | /plan → /tdd → /code-review → /verify |
| 複雑（2時間以上） | /orchestrate feature "..." |
| 超複雑（アーキテクチャ変更） | /orchestrate custom "architect,planner,..." |

### 状況による判断

| 状況 | 推奨コマンド |
|------|-------------|
| ビルドが通らない | /build-fix（Go: /go-build） |
| テストが落ちる | /tdd で修正 |
| PR作成前 | /verify pre-pr |
| コミット前 | /verify pre-commit |
| 前回の続きをしたい | /sessions load |
| バグを調査・修正したい | /orchestrate bugfix "..." |
| セキュリティが重要な機能 | /orchestrate security "..." |
| コードが汚くなってきた | /refactor-clean |
| 学習内容を保存したい | /learn |

## 基本ワークフロー

```
/plan → /tdd → /code-review → /verify → コミット
```

**Go:**
```
/plan → /go-test → /go-review → /verify → コミット
```

**複雑なタスク:**
```
/orchestrate feature "機能の説明"
```

## Hooks（自動実行）

ユーザーが意識する必要はない自動処理:
- ファイル編集後: Prettierフォーマット、TypeScript型チェック
- console.log: 警告表示、セッション終了時に最終チェック
- セッション開始: 前回コンテキスト読み込み
- セッション終了: 状態自動保存
