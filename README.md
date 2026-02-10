# JGI ECC Guide

everything-claude-code（ECC）プラグインのガイドシステム。

## 概要

ECCの24コマンドの中から、「どのコマンドをどう使えばいいか」をガイドする `/guide` コマンドを提供します。

## インストール

### 前提条件

1. **Claude Code** がインストールされていること
2. **ECCプラグイン** がインストールされていること

```bash
# Claude Codeのインストール確認
claude --version

# ECCプラグインのインストール（未インストールの場合）
claude
/plugin marketplace add affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

### セットアップ

新しいプロジェクトディレクトリで以下を実行：

```bash
# プロジェクトディレクトリを作成
mkdir my-project
cd my-project

# JGI ECC Guide をインストール
curl -fsSL https://raw.githubusercontent.com/JGIsup-dev/jgi-ecc-guide/main/install.sh | bash
```

既存ファイルがある場合は上書き確認が表示されます。

## インストール後の構造

```
your-project/
├── CLAUDE.md                          ← プロジェクト設定（初回編集）
└── .claude/
    ├── settings.json                  ← ECC有効化 + Agent Teams設定
    ├── rules/                         ← ECCルール（everything-claude-codeから取得）
    │   ├── agents.md
    │   ├── coding-style.md
    │   ├── git-workflow.md
    │   ├── hooks.md
    │   ├── patterns.md
    │   ├── performance.md
    │   ├── security.md
    │   └── testing.md
    ├── commands/
    │   ├── guide.md                   ← /guide コマンド
    │   └── team.md                    ← /team コマンド（Agent Teams）
    └── skills/
        ├── ecc-guide/
        │   ├── SKILL.md
        │   └── reference/
        │       ├── commands.md
        │       ├── prompts.md
        │       └── workflows.md
        └── ecc-teams/
            ├── SKILL.md
            └── reference/
                ├── configurations.md
                ├── patterns.md
                └── ecc-mapping.md
```

## 使い方

```bash
# プロジェクトディレクトリでClaude Codeを起動
cd my-project
claude

# /guide コマンドで推奨を取得
/guide 認証機能を実装したい
```

出力例：

```
【推奨コマンド】/plan

【プロンプト例】
/plan 認証機能を実装したい。JWT認証でログイン/ログアウト/トークンリフレッシュを含める

【次のステップ】
1. 計画が承認されたら /tdd で実装開始
2. 実装完了後 /code-review でセキュリティ含むレビュー
3. /verify pre-pr で最終検証
```

## CLAUDE.md の初期設定

インストール直後のCLAUDE.mdはテンプレート状態です。プロジェクト開始時に：

1. プロジェクトの概要・技術スタックを記入
2. チーム固有のルールがあれば追記
3. テンプレートの注記ブロックを削除

## ECCコマンド一覧

| カテゴリ | コマンド | 用途 |
|---------|---------|------|
| 計画 | `/plan` | 実装計画の作成 |
| 計画 | `/orchestrate` | 複雑なタスクの分解・並列実行 |
| 実装 | `/tdd` | テスト駆動開発 |
| 実装 | `/go-test` | Go言語のTDD |
| ビルド | `/build-fix` | ビルドエラーの修正 |
| ビルド | `/go-build` | Goビルドエラーの修正 |
| レビュー | `/code-review` | コードレビュー |
| レビュー | `/go-review` | Goコードレビュー |
| レビュー | `/python-review` | Pythonコードレビュー |
| 検証 | `/verify` | 品質検証（pre-commit/pre-pr） |
| 検証 | `/test-coverage` | テストカバレッジ分析 |
| 検証 | `/e2e` | E2Eテスト作成・実行 |
| 検証 | `/eval` | AI出力の評価 |
| 検証 | `/checkpoint` | 進捗確認ポイント |
| リファクタ | `/refactor-clean` | リファクタリング |
| 学習 | `/learn` | コードベースからの学習 |
| 学習 | `/skill-create` | 新しいスキル作成 |
| 学習 | `/evolve` | ルールの進化・改善 |
| 学習 | `/instinct-*` | 直感的な判断パターン |
| ドキュメント | `/update-docs` | ドキュメント更新 |
| ドキュメント | `/update-codemaps` | コードマップ更新 |
| 管理 | `/sessions` | セッション管理 |
| 管理 | `/setup-pm` | プロジェクト管理セットアップ |

## Agent Teams (experimental)

Agent Teamsを使って、複数のClaude Codeインスタンスで並列開発ができます。

### 前提条件

- Claude Code最新版
- Agent Teams実験フラグ有効化（install.shで設定可能）
- tmux推奨（3人以上のチームでは必須級）

### 使い方

```bash
# Claude Codeで /team コマンドを使用
/team フロントエンドとバックエンドを並列で開発したい
```

### 主なチーム構成テンプレート

| 構成名 | 人数 | 用途 |
|--------|-----|------|
| `duo-fullstack` | 2 | フロント+バック並列 |
| `squad-feature` | 3-4 | 大規模機能分割 |
| `review-panel` | 2-3 | 多角的レビュー |
| `tdd-factory` | 2-3 | テスト集中 |
| `bugfix-swarm` | 2-3 | バグ調査修正 |
| `architecture-team` | 3-4 | 設計変更 |
| `sprint-team` | 3-5 | スプリント並列消化 |
| `docs-and-code` | 2 | 実装+ドキュメント |

### `/guide` と `/team` の使い分け

- `/guide`: ソロ作業でどのECCコマンドを使うか迷った時
- `/team`: 複数エージェントで並列開発したい時（2時間以上のタスク向き）

## ライセンス

MIT
