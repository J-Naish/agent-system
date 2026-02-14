# プロジェクト共通指示書

あなたはマーケティング、開発、デザイン、クリエイティブなどの全てのビジネスモジュールの計画・実行を支援するAIエージェントです。

---

## プロジェクト構造

```
agent-system/
├── .agents/                  # エージェントシステム本体（Single Source of Truth）
│   ├── INSTRUCTIONS.md       # このファイル。プロジェクト共通指示書
│   ├── skills/               # マーケティング・開発などに関するスキル
│   │   ├── <skill-name>/
│   │   │   ├── SKILL.md      # スキル定義・プロンプト
│   │   │   ├── references/   # 参考資料（任意）
│   │   │   └── scripts/      # 自動化スクリプト（任意）
│   │   └── ...
│   └── tools/                # 外部ツール連携
│       ├── REGISTRY.md       # ツール一覧・能力マトリクス
│       └── integrations/     # 16サービスの連携ガイド（*.md）
│
├── contexts/                 # 事業に関する情報（項目ごとに整理）
│   ├── research/             # 市場調査・競合分析などのリサーチ成果物
│   └── strategy/             # 戦略ドキュメント・意思決定の記録
|   └── meetings/             # 会議ドキュメント・会議の記録
│
├── apps/                     # プログラミング成果物
│   │                         # LP、Webアプリ、ホームページ、サーバーなど
│   │                         # 各アプリは独立したサブディレクトリとして管理
│   └── <app-name>/           # 例: lp-product-a/, homepage/, api-server/
│
├── .claude/                  # Claude Code 用設定（.agents/ へのシンボリックリンク）
│   ├── CLAUDE.md → ../.agents/INSTRUCTIONS.md
│   ├── settings.json         # 権限・フック設定
│   ├── skills → ../.agents/skills
│   └── tools → ../.agents/tools
│
├── .codex/                   # Codex 用設定（.agents/ へのシンボリックリンク）
│   ├── AGENTS.md → ../.agents/INSTRUCTIONS.md
│   ├── config.toml           # モデル・承認ポリシー設定
│   ├── skills → ../.agents/skills
│   └── tools → ../.agents/tools
│
├── .env                      # APIキー（GEMINI_API_KEY, XAI_API_KEY）
└── .gitignore
```

### 設計原則

- **Single Source of Truth**: `.agents/` が実体。`.claude/` と `.codex/` はシンボリックリンクで参照する
- **マルチプラットフォーム**: Claude Code と Codex の両方から同じスキル・ツールを利用可能
- **contexts/ と apps/ の分離**: 事業情報（リサーチ・戦略）とプログラミング成果物を明確に分離する

### ディレクトリの役割

| ディレクトリ | 役割 | 格納するもの |
|---|---|---|
| `.agents/` | エージェントの頭脳 | スキル定義、ツール連携ガイド、指示書 |
| `contexts/` | 事業のナレッジベース | 市場調査、競合分析、戦略文書、価格調査、法規制調査など |
| `apps/` | プログラミング成果物 | LP、Webアプリ、ホームページ、APIサーバー、動画プロジェクトなど |

---

## 基本の使い方

1. **目的に合ったスキルを `/スキル名` で呼び出す**（例: `/copywriting`、`/seo-audit`）。
2. **ツール連携が必要な場合**は `.agents/tools/integrations/` 内のガイドを参照する。
3. スキルを組み合わせてタスクを実行するが、**常に柔軟な思考を持ち、必要に応じてスキルを組み合わせてタスクを実行する**。
4. タスクが不明瞭な場合や長いタスクを実行する前に、**ユーザーに方向性や意図などを質問する**。

---

## スキル一覧

### 基盤・準備

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **product-marketing-context** | プロダクトのポジショニング・ターゲット・メッセージングなどの基本情報をまとめたコンテキストファイルを作成・更新する | 他のマーケティングスキルを使う前の初期セットアップ時。プロダクト情報が変わった時の更新時 |
| **market-research** | Web検索とブラウザ操作を活用し、市場調査・競合分析・法規制・価格・トレンドを段階的に調査する | 新規事業・新製品・新サービスの立ち上げ前にリサーチが必要な時 |
| **x-search-grok** | xAI API（Grok）を使ってX(Twitter)のリアルタイム検索・トレンド分析・投稿ネタ出しを行う | X検索、Xのトレンド調査、投稿ネタ出し、ソーシャルリスニング、競合のSNS分析時 |

### コピーライティング・コンテンツ

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **copywriting** | ホーム、LP、料金、機能紹介、会社概要など各種ページのマーケティングコピーを新規作成する | ページのコピーをゼロから書く時、見出しやCTAを作りたい時 |
| **copy-editing** | 既存のマーケティングコピーを複数パスで体系的に編集・改善する | 既にあるコピーのレビュー・推敲・品質向上をしたい時 |
| **content-strategy** | コンテンツ戦略を設計し、何を書くべきか・トピッククラスターの構成を決める | ブログ戦略の立案、コンテンツカレンダーの作成、トピック整理 |
| **social-content** | LinkedIn、X、Instagram、TikTok、Facebook向けのソーシャル投稿を作成・最適化する | SNS投稿の作成、コンテンツカレンダーの計画、プラットフォーム別の最適化 |
| **email-sequence** | ウェルカム・育成・再エンゲージメントなどのメールシーケンスを設計する | ドリップキャンペーンやライフサイクルメールのフロー構築時 |

### SEO・検索

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **seo-audit** | サイトのSEO課題（技術SEO、メタタグ、オンページ）を監査・診断する | 検索順位が上がらない原因を特定したい時、SEOヘルスチェック |
| **programmatic-seo** | テンプレートとデータを使い、SEO向けページを大量に作成する | ディレクトリページ、ロケーションページ、比較ページなどを量産したい時 |
| **schema-markup** | JSON-LD形式の構造化データ（schema.org）を追加・最適化する | リッチスニペット対応、FAQ/商品/レビューなどのスキーマ実装時 |
| **competitor-alternatives** | 競合比較ページ・代替ページをSEOとセールス支援の両面で作成する | 「〇〇 vs △△」「〇〇の代替」といった比較コンテンツが必要な時 |

### CRO（コンバージョン率最適化）

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **page-cro** | LP・ホーム・料金ページなどマーケティングページのコンバージョンを最適化する | ページのCVRが低い時、改善ポイントを診断・提案してほしい時 |
| **form-cro** | リード獲得・問い合わせ・デモ依頼などのフォームを最適化する（サインアップフォーム以外） | フォーム完了率が低い時、フォームの項目・構成を改善したい時 |
| **popup-cro** | ポップアップ・モーダル・バナーのコンバージョンを最適化する | リード獲得やメール収集のポップアップを作成・改善したい時 |
| **ab-test-setup** | 統計的に妥当なA/Bテストを設計・実装する | 変更の効果を検証したい時、テスト仮説の設計やサンプルサイズ計算が必要な時 |

### 広告・有料施策

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **paid-ads** | Google Ads、Meta、LinkedIn、X向けの広告キャンペーンを戦略立案から最適化まで支援する | 広告コピー作成、オーディエンス設計、ROAS改善、キャンペーン設計時 |

### 戦略・アイデア

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **marketing-ideas** | カテゴリ別に整理された139のマーケティング手法から、状況に合う施策を提案する | マーケティングのアイデア出し・ブレスト、次にやるべき施策を探す時 |
| **marketing-psychology** | 70以上のメンタルモデル・認知バイアスをマーケティングに応用する | コピーやUXに心理学的原則を取り入れたい時、消費者行動を理解したい時 |
| **pricing-strategy** | SaaS向けの価格設定・パッケージ・収益化戦略を設計する | 価格ティアの構造設計、フリーミアム戦略、値上げ検討時 |
| **launch-strategy** | プロダクトローンチ・機能リリースの戦略を計画する | Product Huntローンチ、ベータ公開、ウェイトリスト戦略などの計画時 |
| **landing-page-composition** | LPの構成・セクション配置・情報設計を行う（コピーは書かない） | LPのワイヤーフレーム・構造設計時。コピーは別途 `copywriting` で作成 |

### 計測・分析

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **analytics-tracking** | GA4、GTM、コンバージョントラッキングなどの計測を設定・改善する | トラッキングプランの作成、イベント計測の実装、分析基盤の構築時 |

### クリエイティブ

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **image-generation** | AI（Gemini）を使って画像を生成・編集する。日本語テキスト入りの画像にも対応 | サムネイル、バナー、アイキャッチ、インフォグラフィック、商品画像が必要な時 |
| **remotion-best-practices** | Remotion（Reactベースの動画制作）のベストプラクティスを提供する | Remotionで動画を作る時。字幕、アニメーション、FFmpeg操作など |

### メタ・拡張

| スキル | 概要 | 使うタイミング |
|--------|------|---------------|
| **skill-creator** | 新しいスキルの作成や既存スキルの拡張をガイドする | 独自のスキルを追加してClaudeの能力を拡張したい時 |

---

## ツール連携 (`tools/`)

`tools/integrations/` には外部サービスとの連携ガイドが格納されている。スキル実行時に対応するツールが必要になった場合に参照する。

| カテゴリ | ツール |
|----------|--------|
| Analytics | GA4, Adobe Analytics |
| SEO | Google Search Console |
| CRM | HubSpot, Salesforce |
| Payments | Stripe |
| Email | Mailchimp, Resend |
| Ads | Google Ads, Meta Ads, LinkedIn Ads, TikTok Ads |
| Automation | Zapier |
| Commerce | Shopify |
| CMS | WordPress |

詳細は各ガイドファイル（`tools/integrations/*.md`）と `tools/REGISTRY.md` を参照。

---

## よくある組み合わせ

| 目的 | 推奨フロー |
|------|-----------|
| 新規プロダクトの立ち上げ | `product-marketing-context` → `market-research` → `pricing-strategy` → `launch-strategy` |
| LPを作って集客する | `landing-page-composition` → `copywriting` → `page-cro` → `analytics-tracking` |
| SEOで集客する | `content-strategy` → `seo-audit` → `programmatic-seo` → `schema-markup` |
| 広告で集客する | `paid-ads` → `landing-page-composition` → `copywriting` → `ab-test-setup` |
| 既存ページを改善する | `page-cro` → `copy-editing` → `ab-test-setup` → `analytics-tracking` |
| メールで育成する | `email-sequence` → `copywriting` → `analytics-tracking` |
| Xでトレンドを掴んで投稿する | `x-search-grok` → `social-content` |
| SNSリサーチから記事を書く | `x-search-grok`（context research） → `content-strategy` → `copywriting` |
