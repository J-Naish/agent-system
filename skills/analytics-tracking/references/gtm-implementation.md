# Google Tag Manager 実装リファレンス

Google Tag Manager 経由でトラッキングを実装するための詳細ガイド。

## コンテナ構造

### タグ

タグは、トリガーされたときに実行されるコードスニペットです。

**一般的なタグタイプ:**
- GA4 Configuration（基本設定）
- GA4 Event（カスタムイベント）
- Google Ads Conversion
- Facebook Pixel
- LinkedIn Insight Tag
- Custom HTML（他ピクセル向け）

### トリガー

トリガーはタグが発火する条件を定義します。

**組み込みトリガー:**
- Page View: All Pages, DOM Ready, Window Loaded
- Click: All Elements, Just Links
- Form Submission
- Scroll Depth
- Timer
- Element Visibility

**カスタムトリガー:**
- Custom Event（dataLayer 由来）
- Trigger Groups（複数条件）

### 変数

変数は動的な値を取得します。

**組み込み（必要に応じて有効化）:**
- Click Text, Click URL, Click ID, Click Classes
- Page Path, Page URL, Page Hostname
- Referrer
- Form Element, Form ID

**ユーザー定義:**
- Data Layer variables
- JavaScript variables
- Lookup tables
- RegEx tables
- Constants

---

## 命名規則

### 推奨フォーマット

```
[Type] - [Description] - [Detail]

Tags:
GA4 - Event - Signup Completed
GA4 - Config - Base Configuration
FB - Pixel - Page View
HTML - LiveChat Widget

Triggers:
Click - CTA Button
Submit - Contact Form
View - Pricing Page
Custom - signup_completed

Variables:
DL - user_id
JS - Current Timestamp
LT - Campaign Source Map
```

---

## Data Layer パターン

### 基本構造

```javascript
// 初期化（GTM より前、<head> 内）
window.dataLayer = window.dataLayer || [];

// イベント送信
dataLayer.push({
  'event': 'event_name',
  'property1': 'value1',
  'property2': 'value2'
});
```

### ページロードデータ

```javascript
// ページ読み込み時に設定（GTM コンテナより前）
window.dataLayer = window.dataLayer || [];
dataLayer.push({
  'pageType': 'product',
  'contentGroup': 'products',
  'user': {
    'loggedIn': true,
    'userId': '12345',
    'userType': 'premium'
  }
});
```

### フォーム送信

```javascript
document.querySelector('#contact-form').addEventListener('submit', function() {
  dataLayer.push({
    'event': 'form_submitted',
    'formName': 'contact',
    'formLocation': 'footer'
  });
});
```

### ボタンクリック

```javascript
document.querySelector('.cta-button').addEventListener('click', function() {
  dataLayer.push({
    'event': 'cta_clicked',
    'ctaText': this.innerText,
    'ctaLocation': 'hero'
  });
});
```

### E コマースイベント

```javascript
// 商品閲覧
dataLayer.push({ ecommerce: null }); // 前回データをクリア
dataLayer.push({
  'event': 'view_item',
  'ecommerce': {
    'items': [{
      'item_id': 'SKU123',
      'item_name': 'Product Name',
      'price': 99.99,
      'item_category': 'Category',
      'quantity': 1
    }]
  }
});

// カート追加
dataLayer.push({ ecommerce: null });
dataLayer.push({
  'event': 'add_to_cart',
  'ecommerce': {
    'items': [{
      'item_id': 'SKU123',
      'item_name': 'Product Name',
      'price': 99.99,
      'quantity': 1
    }]
  }
});

// 購入
dataLayer.push({ ecommerce: null });
dataLayer.push({
  'event': 'purchase',
  'ecommerce': {
    'transaction_id': 'T12345',
    'value': 99.99,
    'currency': 'USD',
    'tax': 5.00,
    'shipping': 10.00,
    'items': [{
      'item_id': 'SKU123',
      'item_name': 'Product Name',
      'price': 99.99,
      'quantity': 1
    }]
  }
});
```

---

## よくあるタグ設定

### GA4 Configuration タグ

**Tag Type:** Google Analytics: GA4 Configuration

**設定:**
- Measurement ID: G-XXXXXXXX
- Send page view: チェック（ページビュー用）
- User Properties: 必要なユーザー単位ディメンションを追加

**Trigger:** All Pages

### GA4 Event タグ

**Tag Type:** Google Analytics: GA4 Event

**設定:**
- Configuration Tag: 設定タグを選択
- Event Name: {{DL - event_name}} または固定値
- Event Parameters: dataLayer からパラメータを追加

**Trigger:** イベント名一致の Custom Event

### Facebook Pixel - 基本

**Tag Type:** Custom HTML

```html
<script>
  !function(f,b,e,v,n,t,s)
  {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
  n.callMethod.apply(n,arguments):n.queue.push(arguments)};
  if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
  n.queue=[];t=b.createElement(e);t.async=!0;
  t.src=v;s=b.getElementsByTagName(e)[0];
  s.parentNode.insertBefore(t,s)}(window, document,'script',
  'https://connect.facebook.net/en_US/fbevents.js');
  fbq('init', 'YOUR_PIXEL_ID');
  fbq('track', 'PageView');
</script>
```

**Trigger:** All Pages

### Facebook Pixel - イベント

**Tag Type:** Custom HTML

```html
<script>
  fbq('track', 'Lead', {
    content_name: '{{DL - form_name}}'
  });
</script>
```

**Trigger:** Custom Event - form_submitted

---

## プレビューとデバッグ

### プレビューモード

1. GTM で「Preview」をクリック
2. サイト URL を入力
3. 画面下に GTM デバッグパネルが表示

**確認ポイント:**
- このイベントで発火したタグ
- 発火しなかったタグ（理由付き）
- 変数と値
- Data Layer の内容

### デバッグのコツ

**タグが発火しない:**
- トリガー条件を確認
- dataLayer.push を確認
- タグシーケンスを確認

**変数値が誤っている:**
- dataLayer 構造を確認
- 変数パス（ネスト）を確認
- タイミングを確認（まだデータがない可能性）

**複数回発火する:**
- トリガーの一意性を確認
- 重複タグを確認
- タグ発火オプションを確認

---

## ワークスペースとバージョン管理

### ワークスペース

チーム開発ではワークスペースを活用:
- 本番運用はデフォルトワークスペース
- 大きな変更は専用ワークスペース
- 準備できたらマージ

### バージョン管理

**ベストプラクティス:**
- すべてのバージョンに分かりやすい名前を付ける
- 変更内容をノートに残す
- 公開前に変更をレビュー
- 本番版を明確に記録

**バージョンノート例:**
```
v15: 購入コンバージョントラッキングを追加
- 新規タグ: GA4 - Event - Purchase
- 新規トリガー: Custom Event - purchase
- 新規変数: DL - transaction_id, DL - value
- テスト: Chrome, Safari, Mobile
```

---

## 同意管理

### Consent Mode 連携

```javascript
// デフォルト状態（同意前）
gtag('consent', 'default', {
  'analytics_storage': 'denied',
  'ad_storage': 'denied'
});

// 同意時に更新
function grantConsent() {
  gtag('consent', 'update', {
    'analytics_storage': 'granted',
    'ad_storage': 'granted'
  });
}
```

### GTM Consent Overview

1. 管理画面で Consent Overview を有効化
2. 各タグの同意設定を構成
3. タグが同意状態を自動で尊重

---

## 高度なパターン

### タグシーケンス

**タグを順番に発火させる設定:**
Tag Configuration > Advanced Settings > Tag Sequencing

**ユースケース:**
- イベントタグより先に設定タグ
- トラッキング前にピクセル初期化
- コンバージョン後のクリーンアップ

### 例外処理

**Trigger exceptions** - タグ発火を防ぐ:
- 特定ページを除外
- 内部トラフィックを除外
- テスト中は除外

### カスタム JavaScript 変数

```javascript
// URL パラメータ取得
function() {
  var params = new URLSearchParams(window.location.search);
  return params.get('campaign') || '(not set)';
}

// Cookie 値取得
function() {
  var match = document.cookie.match('(^|;) ?user_id=([^;]*)(;|$)');
  return match ? match[2] : null;
}

// ページ要素から値取得
function() {
  var el = document.querySelector('.product-price');
  return el ? parseFloat(el.textContent.replace('$', '')) : 0;
}
```
