# GA4 実装リファレンス

Google Analytics 4 の詳細実装ガイド。

## 設定

### データストリーム

- プラットフォームごとに 1 ストリーム（web, iOS, Android）
- 拡張計測を有効化して自動トラッキングを活用
- データ保持を設定（デフォルト 2 か月、最大 14 か月）
- Google Signals を有効化（同意がある場合のクロスデバイス用）

### 拡張計測イベント（自動）

| Event | Description | Configuration |
|-------|-------------|---------------|
| page_view | ページ読み込み | Automatic |
| scroll | 90% スクロール深度 | Toggle on/off |
| outbound_click | 外部ドメインへのクリック | Automatic |
| site_search | 検索クエリ利用 | パラメータを設定 |
| video_engagement | YouTube 動画再生 | Toggle on/off |
| file_download | PDF、ドキュメント等 | 拡張子を設定可能 |

### 推奨イベント

拡張レポート活用のため、可能な限り Google の定義済みイベントを使用:

**全プロパティ共通:**
- login, sign_up
- share
- search

**E コマース:**
- view_item, view_item_list
- add_to_cart, remove_from_cart
- begin_checkout
- add_payment_info
- purchase, refund

**ゲーム:**
- level_up, unlock_achievement
- post_score, spend_virtual_currency

参考: https://support.google.com/analytics/answer/9267735

---

## カスタムイベント

### gtag.js 実装

```javascript
// 基本イベント
gtag('event', 'signup_completed', {
  'method': 'email',
  'plan': 'free'
});

// 値付きイベント
gtag('event', 'purchase', {
  'transaction_id': 'T12345',
  'value': 99.99,
  'currency': 'USD',
  'items': [{
    'item_id': 'SKU123',
    'item_name': 'Product Name',
    'price': 99.99
  }]
});

// ユーザープロパティ
gtag('set', 'user_properties', {
  'user_type': 'premium',
  'plan_name': 'pro'
});

// User ID（ログインユーザー向け）
gtag('config', 'GA_MEASUREMENT_ID', {
  'user_id': 'USER_ID'
});
```

### Google Tag Manager（dataLayer）

```javascript
// カスタムイベント
dataLayer.push({
  'event': 'signup_completed',
  'method': 'email',
  'plan': 'free'
});

// ユーザープロパティ設定
dataLayer.push({
  'user_id': '12345',
  'user_type': 'premium'
});

// E コマース購入
dataLayer.push({
  'event': 'purchase',
  'ecommerce': {
    'transaction_id': 'T12345',
    'value': 99.99,
    'currency': 'USD',
    'items': [{
      'item_id': 'SKU123',
      'item_name': 'Product Name',
      'price': 99.99,
      'quantity': 1
    }]
  }
});

// 送信前に ecommerce をクリア（ベストプラクティス）
dataLayer.push({ ecommerce: null });
dataLayer.push({
  'event': 'view_item',
  'ecommerce': {
    // ...
  }
});
```

---

## コンバージョン設定

### コンバージョン作成

1. **イベントを収集** - GA4 でイベントが発火していることを確認
2. **コンバージョンとして指定** - Admin > Events > Mark as conversion
3. **カウント方式を設定**:
   - セッションごとに 1 回（リード、サインアップ）
   - すべてのイベント（購入）
4. **Google Ads にインポート** - コンバージョン最適化入札に利用

### コンバージョン値

```javascript
// コンバージョン値付きイベント
gtag('event', 'purchase', {
  'value': 99.99,
  'currency': 'USD'
});
```

または、コンバージョン指定時に GA4 管理画面でデフォルト値を設定。

---

## カスタムディメンションと指標

### 使う場面

**カスタムディメンション:**
- セグメント/フィルタしたいプロパティ
- ユーザー属性（プラン種別、業界）
- コンテンツ属性（著者、カテゴリ）

**カスタム指標:**
- 集計したい数値
- スコア、回数、時間

### 設定手順

1. Admin > Data display > Custom definitions
2. ディメンションまたは指標を作成
3. スコープを選択:
   - **Event**: イベント単位（content_type）
   - **User**: ユーザー単位（account_type）
   - **Item**: 商品単位（product_category）
4. パラメータ名を入力（イベントパラメータ名と一致させる）

### 例

| Dimension | Scope | Parameter | Description |
|-----------|-------|-----------|-------------|
| User Type | User | user_type | Free, trial, paid |
| Content Author | Event | author | ブログ記事の著者 |
| Product Category | Item | item_category | E コマースのカテゴリ |

---

## オーディエンス

### オーディエンス作成

Admin > Data display > Audiences

**ユースケース:**
- リマーケティングオーディエンス（Ads へエクスポート）
- セグメント分析
- トリガーベースのイベント

### オーディエンス例

**高意図訪問者:**
- 料金ページを閲覧
- コンバージョンしていない
- 直近 7 日以内

**エンゲージドユーザー:**
- 3 回以上のセッション
- または合計エンゲージメント 5 分以上

**購入者:**
- 購入イベントあり
- 除外または類似拡張向け

---

## デバッグ

### DebugView

有効化方法:
- URL パラメータ: `?debug_mode=true`
- Chrome 拡張: GA Debugger
- gtag: config に `'debug_mode': true`

確認場所: Reports > Configure > DebugView

### リアルタイムレポート

30 分以内のイベントを確認:
Reports > Real-time

### よくある問題

**イベントが表示されない:**
- まず DebugView を確認
- gtag/GTM の発火を確認
- フィルタ除外を確認

**パラメータ値が欠落:**
- カスタムディメンション未作成
- パラメータ名不一致
- 処理待ち（24〜48 時間）

**コンバージョンが記録されない:**
- イベントがコンバージョン指定されていない
- イベント名不一致
- カウント方式の設定（1 回/毎回）

---

## データ品質

### フィルタ

Admin > Data streams > [Stream] > Configure tag settings > Define internal traffic

**除外対象:**
- 社内 IP アドレス
- 開発者トラフィック
- テスト環境

### クロスドメイントラッキング

複数ドメインで分析を共有する場合:

1. Admin > Data streams > [Stream] > Configure tag settings
2. 対象ドメインを設定
3. セッションを共有すべき全ドメインを列挙

### セッション設定

Admin > Data streams > [Stream] > Configure tag settings

- セッションタイムアウト（デフォルト 30 分）
- エンゲージドセッション時間（デフォルト 10 秒）

---

## Google Ads 連携

### リンク設定

1. Admin > Product links > Google Ads links
2. Google Ads で自動タグ設定を有効化
3. Google Ads でコンバージョンをインポート

### オーディエンスエクスポート

GA4 で作成したオーディエンスは Google Ads で以下に利用可能:
- リマーケティングキャンペーン
- Customer Match
- 類似オーディエンス
