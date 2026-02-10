---
name: ecc-teams
description: Agent Teamsで並列開発チームを構成する際のガイド。チーム構成テンプレート、ECCコマンドとロールの対応、調整パターンを提供。ユーザーがチーム開発・並列作業・複数エージェント協調について質問した時に使用。
---

# ECC Teams

Agent Teamsを使った並列開発チーム構成ガイド。

## When to Activate

- ユーザーが「チームで開発したい」「並列で作業したい」と言った時
- ユーザーが「複数エージェントで」「マルチエージェント」と言った時
- ユーザーがAgent Teamsの構成について質問した時
- ユーザーがTeamCreate、タスク分割について聞いた時
- 大規模タスクで並列化が明らかに有効な時

## Reference Files

**チーム構成テンプレート**: See [reference/configurations.md](reference/configurations.md) for 8 team configurations
**調整パターン**: See [reference/patterns.md](reference/patterns.md) for coordination patterns and best practices
**ECCコマンド対応**: See [reference/ecc-mapping.md](reference/ecc-mapping.md) for ECC command to team role mapping

## Quick Reference

### 8つのチーム構成

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

### Prerequisites

- Claude Code最新版
- Agent Teams実験フラグ有効化: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- tmux推奨（3人以上のチームでは必須級）

### 基本ワークフロー

```
1. TeamCreate でチームを作成
2. /plan でタスクを分解
3. TaskCreate で各メンバーにタスクを割り当て
4. Task tool で各メンバーをスポーン（team_name 指定）
5. 各メンバーが並列で作業
6. 全タスク完了後、/verify pre-pr で最終検証
7. SendMessage (shutdown_request) で全メンバーを終了
8. TeamDelete でクリーンアップ
```

### /orchestrate との使い分け

| 判断基準 | /orchestrate | Agent Teams |
|---------|-------------|-------------|
| 実行方式 | 順次 | 並列 |
| 作業者数 | 1インスタンス | 複数インスタンス |
| 適用規模 | 中規模 | 大規模 |
| セットアップ | 不要 | TeamCreate必要 |

**判断基準**: 並列化で2倍以上速くなるか? → Yes なら Agent Teams

## チーム内でのECCコマンド使用ルール

- リーダーは `/plan` でタスクを分解し、`/verify pre-pr` で最終検証
- 各メンバーはタスク完了前に `/verify quick` で自己検証
- 並列作業前に `/checkpoint create` でセーフポイント作成
- レビューアーは `/code-review` で品質チェック
- `/orchestrate` はAgent Teams内では使わない（Agent Teams自体がオーケストレーション）
