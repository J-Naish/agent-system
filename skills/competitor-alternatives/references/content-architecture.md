# 競合ページ向けコンテンツ設計

比較ページをスケーラブルに運用するための、競合データの構造化と維持方法。

## 一元化された競合データ

競合ごとに単一の正しい情報源を作成する:

```
competitor_data/
├── notion.md
├── airtable.md
├── monday.md
└── ...
```

---

## 競合データテンプレート

競合ごとに、以下を記録:

```yaml
name: Notion
website: notion.so
tagline: "オールインワンのワークスペース"
founded: 2016
headquarters: San Francisco

# ポジショニング
primary_use_case: "ドキュメント + 軽量データベース"
target_audience: "柔軟なワークスペースを求めるチーム"
market_position: "高機能・プレミアム"

# 価格
pricing_model: per-seat
free_tier: true
free_tier_limits: "ブロック数制限あり、1ユーザー"
starter_price: $8/user/month
business_price: $15/user/month
enterprise: custom

# 機能（1-5で評価または説明）
features:
  documents: 5
  databases: 4
  project_management: 3
  collaboration: 4
  integrations: 3
  mobile_app: 3
  offline_mode: 2
  api: 4

# 強み（正直に）
strengths:
  - 非常に柔軟でカスタマイズ性が高い
  - 美しくモダンなインターフェース
  - 強力なテンプレートエコシステム
  - 活発なコミュニティ

# 弱み（公平に）
weaknesses:
  - 大規模データベースで遅くなりやすい
  - 高度機能には学習コストがある
  - 専用ツールに比べ自動化が限定的
  - オフラインモードが限定的

# 向いているケース
best_for:
  - オールインワン環境を求めるチーム
  - コンテンツ中心のワークフロー
  - ドキュメント中心で進めるチーム
  - スタートアップや小規模チーム

# 向いていないケース
not_ideal_for:
  - 複雑なプロジェクト管理が必要
  - 非常に大きなデータベース（数千行）
  - 強力なオフライン運用が必要
  - 厳格なコンプライアンス要件のある大企業

# よくある不満（レビュー由来）
common_complaints:
  - "コンテンツが増えると遅くなる"
  - "ワークスペースが大きくなると探しにくい"
  - "モバイルアプリが使いづらい"

# 移行メモ
migration_from:
  difficulty: medium
  data_export: "Markdown, CSV, HTML"
  what_transfers: "ページ、データベース"
  what_doesnt: "自動化設定、連携設定"
  time_estimate: "小規模チームで1-3日"
```

---

## 自社プロダクトデータ

同じ構造で自社データも管理する。正直さを保つ:

```yaml
name: [Your Product]
# ... same fields

strengths:
  - [実際の強み]

weaknesses:
  - [正直な弱み]

best_for:
  - [理想顧客]

not_ideal_for:
  - [他ツールを選ぶべきケース]
```

---

## ページ生成

各ページは一元化データから取得する:

- **[Competitor] Alternative ページ**: 競合データ + 自社データを使用
- **[Competitor] Alternatives ページ**: 競合データ + 自社データ + 他代替候補を使用
- **You vs [Competitor] ページ**: 自社データ + 競合データを使用
- **[A] vs [B] ページ**: 両競合データ + 自社データを使用

**利点**:
- 競合価格を1回更新すれば全ページに反映
- 機能比較を1回追加すれば全ページに表示
- ページ間の精度を一貫して維持
- 大規模運用での保守が容易

---

## インデックスページ構造

### Alternatives インデックス

**URL**: `/alternatives` または `/alternatives/index`

**目的**: すべての "[Competitor] Alternative" ページを一覧化

**ページ構成**:
1. 見出し: "[Your Product] as an Alternative"
2. 乗り換え理由の短い導入
3. すべての代替ページ一覧:
   - 競合名/ロゴ
   - その競合に対する主要差別化要素の1行要約
   - 詳細比較へのリンク
4. 乗り換え理由の共通項（集約）
5. CTA

**例**:
```markdown
## [Your Product] を代替として比較する

乗り換えを検討中ですか？ 比較中のツールに対して [Your Product] がどう違うか確認してください:

- **[Notion Alternative](/alternatives/notion)** — [X] が必要なチームに適している
- **[Airtable Alternative](/alternatives/airtable)** — [Y] が必要なチームに適している
- **[Monday Alternative](/alternatives/monday)** — [Z] が必要なチームに適している
```

---

### Vs 比較インデックス

**URL**: `/vs` または `/compare`

**目的**: すべての "You vs [Competitor]" と "[A] vs [B]" ページを一覧化

**ページ構成**:
1. 見出し: "[Your Product] を比較する"
2. セクション: "[Your Product] vs Competitors" - 直接比較一覧
3. セクション: "Head-to-Head Comparisons" - [A] vs [B] 一覧
4. 簡単な評価方法の注記
5. CTA

---

### インデックスページのベストプラクティス

**常に最新化**: 新しい比較ページを追加したら、該当インデックスにも追加する。

**内部リンク**:
- インデックス → 個別ページ
- 個別ページ → インデックス
- 関連比較ページ同士を相互リンク

**SEO 価値**:
- インデックスページは "project management tool comparisons" のような広い語でも上位化可能
- 個別比較ページへリンク評価を配分できる
- 検索エンジンが比較コンテンツ全体を発見しやすくなる

**並び替えオプション**:
- 人気順（検索ボリューム）
- アルファベット順
- カテゴリ/ユースケース順
- 追加日順（鮮度表示）

**インデックスに含める要素**:
- 信頼性向上のための最終更新日
- 提供中ページ/比較数
- 比較数が多い場合の簡易フィルタ

---

## フッターナビゲーション

サイトフッターは全マーケティングページに表示されるため、競合ページへの強力な内部リンク機会となる。

### Option 1: インデックスページへのリンク（最小構成）

最低限、フッターに比較インデックスへのリンクを追加:

```
Footer
├── Compare
│   ├── Alternatives →  /alternatives
│   └── Comparisons →  /vs
```

これにより、全マーケティングページから比較コンテンツハブへリンク評価を渡せる。

### Option 2: 形式別フッター列（SEO 推奨）

より強い内部リンクのため、作成済み形式ごとに専用列を設け、主要競合へ直接リンク:

```
Footer
├── [Product] vs               ├── Alternatives to            ├── Compare
│   ├── vs Notion              │   ├── Notion Alternative     │   ├── Notion vs Airtable
│   ├── vs Airtable            │   ├── Airtable Alternative   │   ├── Monday vs Asana
│   ├── vs Monday              │   ├── Monday Alternative     │   ├── Notion vs Monday
│   ├── vs Asana               │   ├── Asana Alternative      │   ├── ...
│   ├── vs Clickup             │   ├── Clickup Alternative    │   └── View all →
│   ├── ...                    │   ├── ...                    │
│   └── View all →             │   └── View all →             │
```

**ガイドライン**:
- 1列あたり最大 8 リンク（検索ボリューム上位競合）
- フルインデックスページへの "View all" を追加
- 実際にページがある形式だけ列を作る
- 検索ボリュームが高い競合を優先する

### フッターリンクが重要な理由

1. **サイト全体への分配**: フッターリンクは全マーケティングページに出るため、サイト全体から比較コンテンツへリンク評価を渡せる
2. **クロール効率**: 検索エンジンが全比較ページを素早く発見できる
3. **ユーザー発見性**: 比較検討中の訪問者が関連ページを見つけやすい
4. **競争上の位置づけ**: その領域の主要プレイヤーであることを検索エンジンに示せる

### 実装メモ

- 優先度の高い比較ページ追加時にフッター更新
- フッターは簡潔に保ち、全ページを羅列しない
- 列見出しを URL 構造に合わせる（例: "vs" 列 → `/vs/`）
- モバイル表示を考慮（列が積み上がるため優先順に配置）
