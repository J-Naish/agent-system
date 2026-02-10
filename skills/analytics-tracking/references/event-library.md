# イベントライブラリ リファレンス

ビジネスタイプと文脈ごとに追跡すべきイベントの包括的一覧。

## マーケティングサイトのイベント

### ナビゲーションとエンゲージメント

| Event Name | Description | Properties |
|------------|-------------|------------|
| page_view | ページ読み込み（拡張） | page_title, page_location, content_group |
| scroll_depth | しきい値までスクロール | depth (25, 50, 75, 100) |
| outbound_link_clicked | 外部サイトへのクリック | link_url, link_text |
| internal_link_clicked | サイト内リンククリック | link_url, link_text, location |
| video_played | 動画再生開始 | video_id, video_title, duration |
| video_completed | 動画再生完了 | video_id, video_title, duration |

### CTA とフォーム操作

| Event Name | Description | Properties |
|------------|-------------|------------|
| cta_clicked | Call to action がクリックされた | button_text, cta_location, page |
| form_started | フォーム入力開始 | form_name, form_location |
| form_field_completed | フィールド入力完了 | form_name, field_name |
| form_submitted | フォーム送信成功 | form_name, form_location |
| form_error | フォームバリデーション失敗 | form_name, error_type |
| resource_downloaded | アセットがダウンロードされた | resource_name, resource_type |

### コンバージョンイベント

| Event Name | Description | Properties |
|------------|-------------|------------|
| signup_started | サインアップ開始 | source, page |
| signup_completed | サインアップ完了 | method, plan, source |
| demo_requested | デモフォーム送信 | company_size, industry |
| contact_submitted | 問い合わせフォーム送信 | inquiry_type |
| newsletter_subscribed | メールリスト登録 | source, list_name |
| trial_started | 無料トライアル開始 | plan, source |

---

## プロダクト/アプリのイベント

### オンボーディング

| Event Name | Description | Properties |
|------------|-------------|------------|
| signup_completed | アカウント作成完了 | method, referral_source |
| onboarding_started | オンボーディング開始 | - |
| onboarding_step_completed | ステップ完了 | step_number, step_name |
| onboarding_completed | 全ステップ完了 | steps_completed, time_to_complete |
| onboarding_skipped | オンボーディングをスキップ | step_skipped_at |
| first_key_action_completed | Aha moment に到達 | action_type |

### コア利用

| Event Name | Description | Properties |
|------------|-------------|------------|
| session_started | アプリセッション開始 | session_number |
| feature_used | 機能操作 | feature_name, feature_category |
| action_completed | コアアクション完了 | action_type, count |
| content_created | コンテンツ作成 | content_type |
| content_edited | コンテンツ編集 | content_type |
| content_deleted | コンテンツ削除 | content_type |
| search_performed | アプリ内検索実行 | query, results_count |
| settings_changed | 設定変更 | setting_name, new_value |
| invite_sent | 他ユーザーを招待 | invite_type, count |

### エラーとサポート

| Event Name | Description | Properties |
|------------|-------------|------------|
| error_occurred | エラー発生 | error_type, error_message, page |
| help_opened | ヘルプ表示 | help_type, page |
| support_contacted | サポート問い合わせ | contact_method, issue_type |
| feedback_submitted | フィードバック送信 | feedback_type, rating |

---

## 収益化イベント

### 料金とチェックアウト

| Event Name | Description | Properties |
|------------|-------------|------------|
| pricing_viewed | 料金ページ表示 | source |
| plan_selected | プラン選択 | plan_name, billing_cycle |
| checkout_started | チェックアウト開始 | plan, value |
| payment_info_entered | 支払い情報入力 | payment_method |
| purchase_completed | 購入成功 | plan, value, currency, transaction_id |
| purchase_failed | 購入失敗 | error_reason, plan |

### サブスクリプション管理

| Event Name | Description | Properties |
|------------|-------------|------------|
| trial_started | トライアル開始 | plan, trial_length |
| trial_ended | トライアル終了 | plan, converted (bool) |
| subscription_upgraded | 上位プランへ変更 | from_plan, to_plan, value |
| subscription_downgraded | 下位プランへ変更 | from_plan, to_plan |
| subscription_cancelled | 解約 | plan, reason, tenure |
| subscription_renewed | 更新 | plan, value |
| billing_updated | 支払い方法更新 | - |

---

## E コマースイベント

### 閲覧

| Event Name | Description | Properties |
|------------|-------------|------------|
| product_viewed | 商品ページ表示 | product_id, product_name, category, price |
| product_list_viewed | カテゴリ/一覧表示 | list_name, products[] |
| product_searched | 商品検索実行 | query, results_count |
| product_filtered | フィルター適用 | filter_type, filter_value |
| product_sorted | 並び替え適用 | sort_by, sort_order |

### カート

| Event Name | Description | Properties |
|------------|-------------|------------|
| product_added_to_cart | 商品をカート追加 | product_id, product_name, price, quantity |
| product_removed_from_cart | 商品をカート削除 | product_id, product_name, price, quantity |
| cart_viewed | カートページ表示 | cart_value, items_count |

### チェックアウト

| Event Name | Description | Properties |
|------------|-------------|------------|
| checkout_started | チェックアウト開始 | cart_value, items_count |
| checkout_step_completed | ステップ完了 | step_number, step_name |
| shipping_info_entered | 配送先情報入力 | shipping_method |
| payment_info_entered | 支払い情報入力 | payment_method |
| coupon_applied | クーポン適用 | coupon_code, discount_value |
| purchase_completed | 注文完了 | transaction_id, value, currency, items[] |

### 購入後

| Event Name | Description | Properties |
|------------|-------------|------------|
| order_confirmed | 注文確認表示 | transaction_id |
| refund_requested | 返金申請 | transaction_id, reason |
| refund_completed | 返金処理完了 | transaction_id, value |
| review_submitted | 商品レビュー送信 | product_id, rating |

---

## B2B / SaaS 固有イベント

### チームとコラボレーション

| Event Name | Description | Properties |
|------------|-------------|------------|
| team_created | 新規チーム/組織作成 | team_size, plan |
| team_member_invited | メンバー招待送信 | role, invite_method |
| team_member_joined | 招待受諾 | role |
| team_member_removed | メンバー削除 | role |
| role_changed | 権限変更 | user_id, old_role, new_role |

### 連携イベント

| Event Name | Description | Properties |
|------------|-------------|------------|
| integration_viewed | 連携ページ表示 | integration_name |
| integration_started | 連携設定開始 | integration_name |
| integration_connected | 連携成功 | integration_name |
| integration_disconnected | 連携解除 | integration_name, reason |

### アカウントイベント

| Event Name | Description | Properties |
|------------|-------------|------------|
| account_created | 新規アカウント作成 | source, plan |
| account_upgraded | プランアップグレード | from_plan, to_plan |
| account_churned | アカウント解約 | reason, tenure, mrr_lost |
| account_reactivated | 復帰顧客 | previous_tenure, new_plan |

---

## イベントプロパティ（パラメータ）

### 含める標準プロパティ

**ユーザー文脈:**
```
user_id: "12345"
user_type: "free" | "trial" | "paid"
account_id: "acct_123"
plan_type: "starter" | "pro" | "enterprise"
```

**セッション文脈:**
```
session_id: "sess_abc"
session_number: 5
page: "/pricing"
referrer: "https://google.com"
```

**キャンペーン文脈:**
```
source: "google"
medium: "cpc"
campaign: "spring_sale"
content: "hero_cta"
```

**プロダクト文脈（E コマース）:**
```
product_id: "SKU123"
product_name: "Product Name"
category: "Category"
price: 99.99
quantity: 1
currency: "USD"
```

**時間:**
```
timestamp: "2024-01-15T10:30:00Z"
time_on_page: 45
session_duration: 300
```

---

## ファネルイベントシーケンス

### サインアップファネル
1. signup_started
2. signup_step_completed (email)
3. signup_step_completed (password)
4. signup_completed
5. onboarding_started

### 購入ファネル
1. pricing_viewed
2. plan_selected
3. checkout_started
4. payment_info_entered
5. purchase_completed

### E コマースファネル
1. product_viewed
2. product_added_to_cart
3. cart_viewed
4. checkout_started
5. shipping_info_entered
6. payment_info_entered
7. purchase_completed
