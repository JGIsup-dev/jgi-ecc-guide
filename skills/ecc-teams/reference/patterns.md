# Agent Teams 調整パターン・ベストプラクティス

チームの調整方法、タスク依存パターン、通信パターン、アンチパターンをまとめたリファレンス。

---

## 1. リーダー調整パターン

### delegateモード（推奨）

リーダーは`delegate`モードで起動し、タスク管理と品質ゲートに専念する。

```
役割:
- /plan でタスクを分解
- TaskCreate でメンバーにタスク割り当て
- TaskList で進捗監視
- 全タスク完了後に /verify pre-pr
- メンバー間の調整（SendMessage）
```

**メリット**: リーダーが実装に入らないため、全体を俯瞰できる
**デメリット**: リーダーのリソースが遊ぶ可能性

### アクティブリーダーモード

リーダー自身も実装を担当するパターン。少人数チーム（2名）で有効。

```
役割:
- /plan でタスクを分解
- 自分も一部タスクを /tdd で実装
- 他メンバーの完了を確認
- 最終 /verify pre-pr
```

**メリット**: リソース効率が良い
**デメリット**: 全体把握が疎かになりやすい

### ハイブリッドモード

序盤はdelegate、中盤からアクティブに切り替える。

```
序盤: /plan → TaskCreate → 全員にタスク割り当て
中盤: 自分のタスクを実装しつつ進捗監視
終盤: 統合・最終検証に専念
```

---

## 2. タスク依存パターン

### パイプライン

前のタスクの出力が次のタスクの入力になるパターン。

```
Task A → Task B → Task C
（設計 → 実装 → テスト）
```

```
TaskCreate "API設計" → architect
TaskCreate "API実装" → impl (addBlockedBy: ["設計"])
TaskCreate "APIテスト" → tester (addBlockedBy: ["実装"])
```

### ファンアウト（並列分岐）

1つのタスクから複数タスクが並列に実行されるパターン。

```
        ┌→ Task B-1
Task A ─┼→ Task B-2
        └→ Task B-3
```

```
TaskCreate "設計完了" → leader
TaskCreate "モジュールA" → worker-1 (addBlockedBy: ["設計"])
TaskCreate "モジュールB" → worker-2 (addBlockedBy: ["設計"])
TaskCreate "モジュールC" → worker-3 (addBlockedBy: ["設計"])
```

### ファンイン（並列合流）

複数の並列タスクが完了してから次のタスクに進むパターン。

```
Task B-1 ─┐
Task B-2 ─┼→ Task C
Task B-3 ─┘
```

```
TaskCreate "統合テスト" → leader (addBlockedBy: ["モジュールA", "モジュールB", "モジュールC"])
```

### ダイアモンド

ファンアウト + ファンインの組み合わせ。最も一般的なチームパターン。

```
           ┌→ Task B ─┐
Task A ────┤          ├→ Task D
           └→ Task C ─┘
```

```
TaskCreate "設計" → leader
TaskCreate "フロントエンド" → impl-frontend (addBlockedBy: ["設計"])
TaskCreate "バックエンド" → impl-backend (addBlockedBy: ["設計"])
TaskCreate "統合・検証" → leader (addBlockedBy: ["フロントエンド", "バックエンド"])
```

---

## 3. 通信パターン

### ステータス更新

メンバーはタスク完了時にリーダーへDMで報告する。

```
SendMessage:
  type: "message"
  recipient: "leader"
  content: "モジュールA実装完了。テスト全通過。次のタスクをください"
  summary: "モジュールA完了報告"
```

### ブロッキング報告

メンバーが作業中にブロッカーを発見した場合。

```
SendMessage:
  type: "message"
  recipient: "leader"
  content: "型定義が未確定のため実装が進められません。interfaceの定義を先に確定してください"
  summary: "型定義待ちでブロック中"
```

### ハンドオフ（引き継ぎ）

あるメンバーの成果物を次のメンバーに引き継ぐ。

```
# impl → reviewer
SendMessage:
  type: "message"
  recipient: "reviewer"
  content: "src/auth/ 配下の実装が完了しました。レビューをお願いします"
  summary: "auth実装のレビュー依頼"
```

### broadcast vs DM の使い分け

| 場面 | 方法 | 理由 |
|------|------|------|
| タスク完了報告 | DM（leader宛） | リーダーだけが知ればよい |
| ブロッカー発見 | DM（leader宛） | リーダーが対処を判断 |
| 共有型定義の変更 | broadcast | 全員に影響するため |
| レビュー依頼 | DM（reviewer宛） | 担当者だけが知ればよい |
| 重大な問題発見 | broadcast | 全員に即時停止を促す |

**原則**: broadcastは最小限に。基本はDMで1対1通信。

---

## 4. ECC連携プロトコル

### CLAUDE.md自動読み込み

Agent Teamsの全メンバーは起動時にCLAUDE.mdを自動で読み込む（Claude Code標準動作）。これにより:
- プロジェクトのコーディング規約が全員に共有される
- ECCコマンドの存在を全員が認識する
- 追加の設定は不要

### タスク完了前の自己検証

各メンバーはタスク完了を報告する前に `/verify quick` を実行する。

```
実装完了 → /verify quick → PASS → TaskUpdate completed → leader に報告
                         → FAIL → 修正 → 再度 /verify quick
```

### 全タスク完了後の最終検証

リーダーが全タスク完了を確認したら `/verify pre-pr` を実行する。

```
全タスク完了 → /verify pre-pr → PASS → PR作成
                              → FAIL → 該当メンバーに修正依頼
```

### 並列作業前のチェックポイント

並列作業開始前にリーダーが `/checkpoint create` を実行する。

```
/checkpoint create "before-parallel-work"
→ 並列作業
→ 問題発生時: /checkpoint verify "before-parallel-work" で差分確認
```

---

## 5. 表示モード推奨

### tmux（3人以上で推奨）

複数のClaude Codeインスタンスをペイン分割で表示。

```bash
# 3ペインのtmuxレイアウト例
tmux new-session -s team -d
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
```

**メリット**:
- 全メンバーの出力を同時監視
- セッション切断しても作業継続
- ペイン切り替えで操作可能

### iTerm2（macOS）

タブまたはペイン分割で複数インスタンスを表示。

**メリット**:
- GUIで直感的な操作
- プロファイル設定で色分け可能

### in-process（2人まで）

1つのターミナルでリーダーが操作し、メンバーはバックグラウンド。

**メリット**:
- セットアップ不要
- シンプル

**デメリット**:
- メンバーの出力が見えにくい
- 3人以上では管理困難

---

## 6. アンチパターン

### メンバー過多

**問題**: 5人超のチームは調整コストが実装効率を上回る
**解決**: 最大4-5人。それ以上はサブチームに分割

### タスク依存未定義

**問題**: blockedBy を設定せず、タスクの実行順序が不明確
**解決**: 必ず addBlockedBy でタスク間の依存を明示する

```
# NG: 依存関係なし
TaskCreate "バックエンド実装"
TaskCreate "統合テスト"

# OK: 依存関係あり
TaskCreate "バックエンド実装" → impl
TaskCreate "統合テスト" → tester (addBlockedBy: ["バックエンド実装"])
```

### 型定義・インターフェース共有なし

**問題**: 並列実装でAPI仕様の不一致が発生
**解決**: 実装開始前にリーダーがインターフェース定義を確定し、全員に共有

```
# リーダーがまず型定義ファイルを作成
TaskCreate "APIインターフェース定義" → leader
TaskCreate "フロントエンド実装" → impl-frontend (addBlockedBy: ["インターフェース定義"])
TaskCreate "バックエンド実装" → impl-backend (addBlockedBy: ["インターフェース定義"])
```

### マージ後検証忘れ

**問題**: 並列作業の結果をマージしたが、統合テストを実行しない
**解決**: 全タスク完了後に必ず `/verify pre-pr` を実行

### 全員broadcastの乱用

**問題**: すべての通信をbroadcastで行い、全員の作業が中断される
**解決**: 基本はDM。broadcastは重大な問題発見時のみ

### リーダー不在の並列作業

**問題**: リーダーなしで全員が実装に入り、方向性がばらばらに
**解決**: 必ずリーダーが /plan → タスク分割を行ってから並列作業を開始

### 過度な依存チェーン

**問題**: A→B→C→D→E と長い依存チェーンで実質的に並列化できない
**解決**: ファンアウト・ファンインパターンで並列化ポイントを増やす

```
# NG: 直列チェーン
A → B → C → D → E

# OK: 並列化
A → B₁ → D
  → B₂ → D
  → B₃ → D
       → E
```
