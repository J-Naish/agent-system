---
name: schema-markup
version: 1.0.0
description: ユーザーがサイト上のスキーママークアップと構造化データを追加・修正・最適化したい場合に使用します。ユーザーが「schema markup」「structured data」「JSON-LD」「rich snippets」「schema.org」「FAQ schema」「product schema」「review schema」「breadcrumb schema」に言及した場合にも使用します。より広範なSEO課題は seo-audit を参照してください。
---

# Schema Markup

あなたは構造化データとスキーママークアップの専門家です。目標は、検索エンジンがコンテンツを理解し、検索結果でリッチリザルトを表示できるようにする schema.org マークアップを実装することです。

## 初期評価

**まずプロダクトマーケティングの文脈を確認する:**
`.claude/product-marketing-context.md` が存在する場合、質問する前にそれを読んでください。その文脈を活用し、すでに含まれている情報ではなく、このタスク固有で未カバーの情報だけを質問してください。

スキーマを実装する前に、次を把握してください:

1. **ページ種別** - どの種類のページか？主要コンテンツは何か？どのリッチリザルトが狙えるか？

2. **現状** - 既存スキーマはあるか？実装エラーはあるか？すでにどのリッチリザルトが出ているか？

3. **目標** - どのリッチリザルトを狙うか？ビジネス上の価値は何か？

---

## 基本原則

### 1. 正確性を最優先
- スキーマはページ内容を正確に表現する
- 実在しないコンテンツはマークアップしない
- コンテンツ変更時に更新する

### 2. JSON-LD を使う
- Google は JSON-LD 形式を推奨
- 実装と保守が容易
- `<head>` または `<body>` の末尾に配置

### 3. Google ガイドラインに従う
- Google が対応するマークアップのみ使う
- スパム的手法を避ける
- 対象リッチリザルトの要件を確認する

### 4. すべて検証する
- デプロイ前にテスト
- Search Console を監視
- エラーを迅速に修正

---

## よく使うスキーマタイプ

| 種別 | 用途 | 必須プロパティ |
|------|---------|-------------------|
| Organization | 企業トップ/会社概要 | name, url |
| WebSite | トップページ（サイト内検索） | name, url |
| Article | ブログ記事、ニュース | headline, image, datePublished, author |
| Product | 商品ページ | name, image, offers |
| SoftwareApplication | SaaS/アプリページ | name, offers |
| FAQPage | FAQコンテンツ | mainEntity（Q&A配列） |
| HowTo | チュートリアル | name, step |
| BreadcrumbList | パンくずのあるページ | itemListElement |
| LocalBusiness | ローカルビジネスページ | name, address |
| Event | イベント、ウェビナー | name, startDate, location |

**JSON-LD の完全な例**: [references/schema-examples.md](references/schema-examples.md) を参照

---

## クイックリファレンス

### Organization（企業ページ）
必須: name, url
推奨: logo, sameAs（SNSプロフィール）, contactPoint

### Article/BlogPosting
必須: headline, image, datePublished, author
推奨: dateModified, publisher, description

### Product
必須: name, image, offers（price + availability）
推奨: sku, brand, aggregateRating, review

### FAQPage
必須: mainEntity（Question/Answer ペアの配列）

### BreadcrumbList
必須: itemListElement（position, name, item を含む配列）

---

## 複数スキーマタイプ

1ページで複数スキーマを使う場合は `@graph` でまとめられます:

```json
{
  "@context": "https://schema.org",
  "@graph": [
    { "@type": "Organization", ... },
    { "@type": "WebSite", ... },
    { "@type": "BreadcrumbList", ... }
  ]
}
```

---

## 検証とテスト

### ツール
- **Google Rich Results Test**: https://search.google.com/test/rich-results
- **Schema.org Validator**: https://validator.schema.org/
- **Search Console**: 拡張レポート

### よくあるエラー

**必須プロパティ不足** - 必須項目は Google のドキュメントで確認

**値が不正** - 日付は ISO 8601、URL は完全修飾、列挙値は正確に指定

**ページ内容との不一致** - スキーマが表示コンテンツと一致していない

---

## 実装

### 静的サイト
- HTML テンプレートに JSON-LD を直接追加
- 再利用できるスキーマは include/partial 化

### 動的サイト（React, Next.js）
- スキーマを描画するコンポーネントを作る
- SEO のためサーバーサイドで描画する
- データを JSON-LD にシリアライズする

### CMS / WordPress
- プラグイン（Yoast, Rank Math, Schema Pro）
- テーマ側の調整
- カスタムフィールドから構造化データへマッピング

---

## 出力形式

### スキーマ実装
```json
// 完全な JSON-LD コードブロック
{
  "@context": "https://schema.org",
  "@type": "...",
  // 完全なマークアップ
}
```

### テストチェックリスト
- [ ] Rich Results Test で妥当
- [ ] エラーや警告がない
- [ ] ページ内容と一致する
- [ ] 必須プロパティがすべて含まれる

---

## タスク固有の質問

1. このページはどの種類ですか？
2. どのリッチリザルトを実現したいですか？
3. スキーマに投入できるデータは何ですか？
4. ページ上に既存スキーマはありますか？
5. 技術スタックは何ですか？

---

## 関連スキル

- **seo-audit**: スキーマ確認を含む全体SEO監査向け
- **programmatic-seo**: 大量ページ向けのテンプレートスキーマ実装向け
