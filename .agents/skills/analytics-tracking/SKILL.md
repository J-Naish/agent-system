---
name: analytics-tracking
version: 1.0.0
description: ユーザーが分析トラッキングと計測を設定・改善・監査したいときに使用します。ユーザーが「トラッキング設定」「GA4」「Google Analytics」「コンバージョントラッキング」「イベントトラッキング」「UTM パラメータ」「タグマネージャー」「GTM」「分析実装」「トラッキングプラン」に言及した場合にも使用します。A/B テストの計測については ab-test-setup を参照してください。
---

# Analytics Tracking

あなたは分析実装と計測の専門家です。目標は、マーケティングとプロダクトの意思決定に活用できる示唆を得られるトラッキングを構築できるよう支援することです。

## 初期評価

**まずプロダクトマーケティングコンテキストを確認する:**

トラッキングを実装する前に、以下を把握してください。

1. **ビジネス文脈** - このデータはどの意思決定に使いますか？主要コンバージョンは何ですか？
2. **現在の状態** - 既存のトラッキングは何がありますか？どのツールを使っていますか？
3. **技術的文脈** - 技術スタックは何ですか？プライバシー/コンプライアンス要件はありますか？

---

## コア原則

### 1. データ収集ではなく意思決定のために追跡する
- すべてのイベントは意思決定に結びつくべき
- 見栄えだけの指標を避ける
- イベントは量より質

### 2. 問いから始める
- 何を知る必要があるか？
- このデータに基づいてどんな行動を取るか？
- 必要なトラッキングを逆算する

### 3. 命名を一貫させる
- 命名規則は重要
- 実装前にパターンを決める
- すべてを文書化する

### 4. データ品質を維持する
- 実装を検証する
- 問題を監視する
- データは量よりクリーンさ

---

## トラッキングプランのフレームワーク

### 構造

```
イベント名 | カテゴリ | プロパティ | トリガー | 備考
---------- | -------- | ---------- | ------- | -----
```

### イベント種類

| 種類 | 例 |
|------|----------|
| ページビュー | 自動収集、メタデータで拡張 |
| ユーザー操作 | ボタンクリック、フォーム送信、機能利用 |
| システムイベント | サインアップ完了、購入、サブスク変更 |
| カスタムコンバージョン | 目標達成、ファネル段階 |

**包括的なイベント一覧**: [references/event-library.md](references/event-library.md) を参照

---

## イベント命名規則

### 推奨フォーマット: Object-Action

```
signup_completed
button_clicked
form_submitted
article_read
checkout_payment_completed
```

### ベストプラクティス
- 小文字 + アンダースコア
- 具体的に: `button_clicked` より `cta_hero_clicked`
- コンテキストはイベント名ではなくプロパティに含める
- スペースや特殊文字を避ける
- 判断理由を文書化する

---

## 必須イベント

### マーケティングサイト

| イベント | プロパティ |
|-------|------------|
| cta_clicked | button_text, location |
| form_submitted | form_type |
| signup_completed | method, source |
| demo_requested | - |

### プロダクト/アプリ

| イベント | プロパティ |
|-------|------------|
| onboarding_step_completed | step_number, step_name |
| feature_used | feature_name |
| purchase_completed | plan, value |
| subscription_cancelled | reason |

**ビジネスタイプ別の完全なイベントライブラリ**: [references/event-library.md](references/event-library.md) を参照

---

## イベントプロパティ

### 標準プロパティ

| カテゴリ | プロパティ |
|----------|------------|
| ページ | page_title, page_location, page_referrer |
| ユーザー | user_id, user_type, account_id, plan_type |
| キャンペーン | source, medium, campaign, content, term |
| プロダクト | product_id, product_name, category, price |

### ベストプラクティス
- 一貫したプロパティ名を使う
- 必要な文脈を含める
- 自動取得されるプロパティを重複させない
- プロパティに PII を含めない

---

## GA4 実装

### クイックセットアップ

1. GA4 プロパティとデータストリームを作成
2. gtag.js または GTM を導入
3. 拡張計測を有効化
4. カスタムイベントを設定
5. 管理画面でコンバージョン指定

### カスタムイベント例

```javascript
gtag('event', 'signup_completed', {
  'method': 'email',
  'plan': 'free'
});
```

**GA4 の詳細実装**: [references/ga4-implementation.md](references/ga4-implementation.md) を参照

---

## Google Tag Manager

### コンテナ構造

| コンポーネント | 目的 |
|-----------|---------|
| タグ | 実行されるコード（GA4、ピクセルなど） |
| トリガー | タグ発火条件（ページビュー、クリックなど） |
| 変数 | 動的な値（クリック文言、data layer など） |

### Data Layer パターン

```javascript
dataLayer.push({
  'event': 'form_submitted',
  'form_name': 'contact',
  'form_location': 'footer'
});
```

**GTM の詳細実装**: [references/gtm-implementation.md](references/gtm-implementation.md) を参照

---

## UTM パラメータ戦略

### 標準パラメータ

| パラメータ | 目的 | 例 |
|-----------|---------|---------|
| utm_source | 流入元 | google, newsletter |
| utm_medium | マーケティング媒体 | cpc, email, social |
| utm_campaign | キャンペーン名 | spring_sale |
| utm_content | バージョン識別 | hero_cta |
| utm_term | 広告キーワード | running+shoes |

### 命名規則
- すべて小文字
- アンダースコアまたはハイフンを統一
- 簡潔かつ具体的に: `cta1` ではなく `blog_footer_cta`
- すべての UTM をスプレッドシートで管理

---

## デバッグと検証

### テストツール

| ツール | 用途 |
|------|---------|
| GA4 DebugView | リアルタイムイベント監視 |
| GTM プレビューモード | 公開前のトリガーテスト |
| ブラウザ拡張 | Tag Assistant, dataLayer Inspector |

### 検証チェックリスト

- [ ] 正しいトリガーでイベント発火
- [ ] プロパティ値が正しく入っている
- [ ] 重複イベントがない
- [ ] ブラウザとモバイルで動作する
- [ ] コンバージョンが正しく記録される
- [ ] PII 漏えいがない

### よくある問題

| 問題 | 確認項目 |
|-------|-------|
| イベントが発火しない | トリガー設定、GTM 読み込み |
| 値が誤っている | 変数パス、data layer 構造 |
| イベント重複 | コンテナ重複、トリガー二重発火 |

---

## プライバシーとコンプライアンス

### 考慮事項
- EU/UK/CA では Cookie 同意が必要
- 分析プロパティに PII を含めない
- データ保持設定
- ユーザー削除対応

### 実装
- Consent mode を使う（同意待ち）
- IP 匿名化
- 必要なデータのみ収集
- 同意管理プラットフォームと連携

---

## 出力形式

### トラッキング計画書

```markdown
# [サイト/プロダクト] トラッキング計画

## 概要
- ツール: GA4, GTM
- 最終更新日: [日付]

## イベント

| イベント名 | 説明 | プロパティ | トリガー |
|------------|-------------|------------|---------|
| signup_completed | ユーザーがサインアップ完了 | method, plan | 完了ページ |

## カスタムディメンション

| 名前 | スコープ | パラメータ |
|------|-------|-----------|
| user_type | ユーザー | user_type |

## コンバージョン

| コンバージョン | イベント | カウント方式 |
|------------|-------|----------|
| Signup | signup_completed | セッションごとに 1 回 |
```

---

## タスク固有の質問

1. どのツールを使っていますか（GA4、Mixpanel など）？
2. どの主要アクションを計測したいですか？
3. このデータはどんな意思決定に使いますか？
4. 実装担当は開発チームですか、マーケチームですか？
5. プライバシー/同意要件はありますか？
6. 現在何が計測済みですか？

---

## ツール連携

実装については [tools registry](../../tools/REGISTRY.md) を参照。主要な分析ツール:

| Tool | Best For | MCP | Guide |
|------|----------|:---:|-------|
| **GA4** | Web analytics, Google ecosystem | ✓ | [ga4.md](../../tools/integrations/ga4.md) |
| **Mixpanel** | Product analytics, event tracking | - | [mixpanel.md](../../tools/integrations/mixpanel.md) |
| **Amplitude** | Product analytics, cohort analysis | - | [amplitude.md](../../tools/integrations/amplitude.md) |
| **PostHog** | Open-source analytics, session replay | - | [posthog.md](../../tools/integrations/posthog.md) |
| **Segment** | Customer data platform, routing | - | [segment.md](../../tools/integrations/segment.md) |

---

## 関連スキル

- **seo-audit**: オーガニック流入分析向け
- **page-cro**: コンバージョン最適化向け（このデータを利用）
