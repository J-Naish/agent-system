---
name: market-research
description: Web検索とブラウザ自動操作を活用した包括的な市場調査スキル。市場調査、競合分析、法規制調査、価格調査、トレンド分析を段階的に実施する。ユーザーが新規事業、新製品、新サービスの立ち上げに際してリサーチを必要とする場合や、「市場を調べて」「競合を分析して」「トレンドを調査して」などのリクエストに対して使用する。
---

# マーケットリサーチ

Web検索（WebSearch / WebFetch）とブラウザ自動操作（Claude in Chrome）を組み合わせ、5つの調査領域を段階的に実施する。

## リサーチの全体フロー

以下の5ステップを順番に実行する。各ステップの詳細はreferencesファイルを参照すること。

1. **市場調査** → [references/market-research.md](references/market-research.md)
2. **競合分析** → [references/competitor-analysis.md](references/competitor-analysis.md)
3. **法規制・関連法令** → [references/regulatory-research.md](references/regulatory-research.md)
4. **価格調査** → [references/pricing-research.md](references/pricing-research.md)
5. **トレンド分析** → [references/trend-analysis.md](references/trend-analysis.md)

ユーザーが特定の領域のみを依頼した場合は、該当するステップのみ実行する。

## 検索の基本ルール

### 複数ソースの原則

1つのトピックにつき**最低3〜5回**の異なるクエリで検索し、**2〜3件以上**のソースをWebFetchで本文まで読むこと。1つのサイトの情報だけでアウトプットしてはならない。

### クエリ設計

- **広→狭のファネル戦略**: まず全体像を掴み、次に絞り込む
- **毎回クエリを変える**: 同じ言い回しの繰り返しは同じ結果しか返さない。類義語・視点を変える
- **年を入れる**: 鮮度が重要な情報には必ず年を明記する
- **言語を切り替える**: 日本語で情報が少なければ英語で検索する
- **比較・対立軸を使う**: 比較クエリは質の高い分析記事がヒットしやすい

### 検索演算子の活用

検索精度を上げるために以下の演算子を積極的に使うこと：

| 演算子 | 用途 | 例 |
|--------|------|-----|
| `"完全一致"` | フレーズ完全一致検索 | `"市場規模 2025" SaaS` |
| `site:` | 特定サイト内検索 | `site:meti.go.jp 電子商取引 市場規模` |
| `filetype:` | ファイル形式指定（PDF等のレポート発掘） | `filetype:pdf [業種] 市場調査 2025` |
| `intitle:` | タイトルにキーワードを含むページ | `intitle:市場規模 [業種]` |
| `-除外ワード` | ノイズの除外 | `CRM 比較 -Salesforce`（Salesforce以外を探す） |
| `OR` | いずれかを含む | `(SaaS OR クラウド) 市場規模 2025` |
| `before:` / `after:` | 日付範囲の指定 | `[業種] トレンド after:2024-01-01` |

**一次情報を狙うsite:指定の例：**
- 官公庁: `site:go.jp`（経産省、総務省など）
- 業界団体: `site:or.jp`
- 調査会社: `site:statista.com` `site:grandviewresearch.com`

### 検索→取得の2ステップ

```
Step 1: WebSearchで検索 → URLリストを取得
Step 2: WebFetchで上位の有望なURLの中身を読み込む → 詳細な情報を取得
```

スニペットだけで判断せず、重要な情報はWebFetchで本文を読むこと。

## 外部調査ツールの活用（Claude in Chrome）

市場調査、競合分析、トレンド分析では、以下のツールをClaude in Chromeで閲覧し、広告クリエイティブ・出稿状況・キーワードトレンドを調べること。

### 広告ライブラリ

| ツール | URL | 用途 |
|--------|-----|------|
| Meta広告ライブラリ | `https://www.facebook.com/ads/library/` | Facebook/Instagram広告の検索・閲覧 |
| Google広告の透明性センター | `https://adstransparency.google.com/?region=JP` | Google広告の検索・閲覧 |
| TikTok Top Ads | `https://ads.tiktok.com/business/creativecenter/inspiration/topads/pc/ja?period=30&region=JP` | TikTok広告のパフォーマンス上位クリエイティブ閲覧 |
| TikTokキーワードインサイト | `https://ads.tiktok.com/business/creativecenter/keyword-insights/pc/ja` | TikTok広告で使われているキーワードのトレンド |

### トレンドツール

| ツール | URL | 用途 |
|--------|-----|------|
| Googleトレンド | `https://trends.google.com/trends/` | キーワードの検索ボリューム推移、地域別の関心度、関連トピック |

### 調査手順

1. Claude in Chromeで対象ツールにアクセスする
2. 企業名、ブランド名、または業界キーワードで検索する
3. 以下の観点で情報を収集する：
   - **広告ライブラリ**: クリエイティブの内容、訴求ポイント、掲載期間、出稿量
   - **TikTok Top Ads**: パフォーマンス上位の広告の訴求パターン、フォーマット
   - **TikTokキーワードインサイト**: 注目キーワード、トレンドの変化
   - **Googleトレンド**: 検索関心度の推移、季節性、地域差、関連クエリ
4. 複数の競合やキーワードを比較し、傾向をまとめる

## アウトプットルール

### ファイル出力

リサーチ結果は会話内に留めず、必ずマークダウンファイルとして出力すること。

- **出力先**: プロジェクトルート直下に `research/` ディレクトリを作成し、その中に出力する
- **ファイル名**: `research/[調査テーマ]-research-[YYYY-MM-DD].md`
  - 例: `research/pet-food-ec-research-2025-06-15.md`

### ソースURLの記載

すべての発見事項・データには、情報源のURLを必ず記載すること。URLのないデータは信頼性が担保できないため、出力に含めてはならない。

### ファイル構成テンプレート

```markdown
# [調査テーマ] マーケットリサーチ

調査日: YYYY-MM-DD

---

## 1. 市場調査

### 要約
[3〜5行の要約]

### 主要な発見事項
- 発見事項1
  - ソース: [サイト名](URL)
- 発見事項2
  - ソース: [サイト名](URL)

### 示唆・考察
[調査結果から導かれる示唆や考察]

---

## 2. 競合分析
（同上の形式）

---

（以降、各調査領域を同じ形式で記述）

---

## 総括

### 全体の要約
[全調査を踏まえた3〜5行の総括]

### 主要な機会
- 機会1
- 機会2

### 主要なリスク
- リスク1
- リスク2

---

## 参照ソース一覧

| # | サイト名 | URL | 参照セクション |
|---|----------|-----|----------------|
| 1 | [名前] | URL | 市場調査 |
| 2 | [名前] | URL | 競合分析 |
（調査中に参照したすべてのURLをここにまとめる）
```

すべてのステップが完了したら、末尾に参照ソース一覧を追加し、調査全体で使用したURLを一覧化する。
