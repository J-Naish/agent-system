# Agent System

マーケティング、開発、デザイン、クリエイティブなど、ビジネスの全モジュールを支援するAIエージェントシステム。Claude Code と Codex の両方で動作する。

## クイックスタート

```bash
# 1. リポジトリをクローン
git clone <repo-url> && cd agent-system

# 2. APIキーを設定
cp .env.example .env
# .env を編集して GEMINI_API_KEY, XAI_API_KEY, PAGE_SPEED_INSIGHTS_API_KEYなどを入力

# 3. Claude Code または Codex で開く
```

スキルを `/スキル名` で呼び出して使う：

```
/copywriting          # マーケティングコピー作成
/seo-audit            # SEO診断
/google-ads-strategy  # Google広告の戦略設計
```

## プロジェクト構造

```
agent-system/
├── .agents/                    # エージェントシステム本体（Single Source of Truth）
│   ├── INSTRUCTIONS.md         # 共通指示書・スキル一覧
│   └── skills/                 # 24のスキル定義
│
├── .claude/                    # Claude Code 設定
│   ├── CLAUDE.md               # → .agents/INSTRUCTIONS.md（シンボリックリンク）
│   ├── settings.json
│   └── skills/                 # → .agents/skills/（シンボリックリンク or 実体）
│
├── .codex/                     # Codex 設定
│   ├── AGENTS.md               # → .agents/INSTRUCTIONS.md（シンボリックリンク）
│   ├── config.toml
│   └── skills/                 # → .agents/skills/（シンボリックリンク）
│
├── contexts/                   # 事業に関する情報
│   ├── data/                   # 各種データ（CSV、JSON、Excelなど）
│   ├── research/               # 市場調査・競合分析などのリサーチ成果物
│   ├── strategy/               # 戦略ドキュメント・意思決定の記録
│   └── meetings/               # 会議ドキュメント・会議の記録
│
├── dev/                        # プログラミング成果物（LP、Webアプリなど）
├── sync-template.sh            # テンプレートリポジトリからの同期スクリプト
├── .env                        # APIキー（.gitignore で管理）
└── .env.example
```

## テンプレート同期

このリポジトリはテンプレートとして運用される。各プロジェクトはこのリポジトリをクローンして開始し、プロジェクト固有の情報は `contexts/` や `dev/` に蓄積していく。

テンプレート側でスキルや設定が更新された場合、プロジェクト側で以下を実行して反映する：

```bash
./sync-template.sh
```

`.agents/`、`.claude/`、`.codex/`、`.gitignore`、`.env.example` が上書き同期される。`contexts/` や `dev/` など、プロジェクト固有のデータには影響しない。

## Single Source of Truth 設計

- `.agents/` にスキル定義と指示書の実体を集約
- `.claude/` と `.codex/` はシンボリックリンクで `.agents/` を参照
- 変更は `.agents/` に加えるだけで Claude Code・Codex の両方に反映

## 設定ファイル

| ファイル | 用途 |
|---------|------|
| `.env` | APIキー（`.gitignore` で管理） |
| `.claude/settings.json` | Claude Code の権限・フック設定 |
| `.codex/config.toml` | Codex のモデル・承認ポリシー設定 |
