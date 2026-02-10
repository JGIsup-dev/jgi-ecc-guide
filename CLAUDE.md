# プロジェクト CLAUDE.md

> **初回セットアップ**: このファイルはテンプレートです。プロジェクト開始時に以下を実行してください：
> 1. プロジェクトの概要・技術スタックをヒアリング
> 2. このCLAUDE.mdを実際のプロジェクト情報で埋める
> 3. 完成後、この注記ブロックを削除

## プロジェクト概要

[プロジェクトの説明 - 何をするか、技術スタック]

## 重要ルール

### 1. コード構成

- 大きなファイルより小さなファイルを多数
- 高凝集・低結合
- 1ファイル200-400行が目安、最大800行
- 種類別ではなく機能/ドメイン別に整理

### 2. コードスタイル

- コード・コメント・ドキュメントに絵文字禁止
- 常にイミュータブル - オブジェクトや配列を変更しない
- 本番コードにconsole.log禁止
- try/catchで適切なエラーハンドリング
- Zodなどで入力バリデーション

### 3. テスト

- TDD: テストを先に書く
- カバレッジ最低80%
- ユーティリティにはユニットテスト
- APIには統合テスト
- 重要フローにはE2Eテスト

### 4. セキュリティ

- シークレットのハードコード禁止
- 機密データは環境変数で管理
- すべてのユーザー入力をバリデーション
- パラメータ化クエリのみ使用
- CSRF対策を有効化

## ファイル構成

```
[プロジェクトのディレクトリ構造を記載]
```

## 主要パターン

### APIレスポンス形式

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}
```

### エラーハンドリング

```typescript
try {
  const result = await operation()
  return { success: true, data: result }
} catch (error) {
  console.error('Operation failed:', error)
  return { success: false, error: 'ユーザー向けメッセージ' }
}
```

## 環境変数

```bash
# 必須
DATABASE_URL=
API_KEY=

# オプション
DEBUG=false
```

## 利用可能なコマンド

ECCプラグインのコマンドを使用。迷ったら `/guide` で相談。

```
/guide 〇〇したい   # 何を使えばいいかガイド
/team 〇〇をチームで  # Agent Teamsの構成ガイド
/plan             # 実装計画作成
/tdd              # テスト駆動開発
/code-review      # コードレビュー
/verify           # 検証
/build-fix        # ビルドエラー修正
```

## Gitワークフロー

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- mainに直接コミット禁止
- PRはレビュー必須
- マージ前に全テスト通過必須
