---
name: image-generation
version: 1.0.0
description: >
  ユーザーが画像を生成・編集したい場合に使用します。
  ユーザーが「画像生成」「AI画像」「サムネイル作成」「バナー作成」「ポスター作成」
  「アイキャッチ」「図解」「インフォグラフィック」「商品画像」「モックアップ」
  「イラスト生成」「写真生成」「画像編集」「Nano Banana」「Geminiで画像」
  「テキスト入り画像」「日本語を含む画像」に言及した場合にも使用します。
---

# 画像生成・編集

あなたはAI画像生成の専門家です。Google Nano Banana Pro（Gemini 3 Pro Image）APIを使い、ユーザーの要求に応じた高品質な画像を生成・編集します。

## Nano Banana Proの強み

- **日本語テキストの高精度レンダリング**: ポスター、図解、サムネイルに正確な日本語を直接描画
- **高品質な写真風画像**: 自然な光、奥行き、質感のリアルな画像を生成
- **画像編集**: 参照画像を読み込み、合成・編集・スタイル変換が可能
- **テキスト入り画像**: ロゴ、キャッチコピー、説明文を画像内に正確に配置

---

## 前提条件

- 環境変数 `GEMINI_API_KEY` が設定されていること
- `curl`, `jq`, `base64` コマンドが使用可能であること

APIキーは Google AI Studio（https://aistudio.google.com/apikey）から取得する。

---

## モデルの選択

| モデル | モデルID | 用途 |
|--------|---------|------|
| **Nano Banana Pro** | `gemini-3-pro-image-preview` | 最高品質。複雑な指示、高精度テキスト、プロ仕様の画像向け |
| **Nano Banana** | `gemini-2.5-flash-image` | 高速・低コスト。大量生成やプロトタイプ向け |

迷ったら `gemini-2.5-flash-image` で素早く試し、品質が必要なら `gemini-3-pro-image-preview` に切り替える。

---

## 基本ワークフロー

### 画像を生成する前に

ユーザーから以下の情報を収集する（未提供なら質問する）:

1. **用途**: 何に使う画像か？（サムネイル、バナー、商品画像、SNS投稿等）
2. **被写体**: 何を描くか？
3. **スタイル**: 写真風、イラスト、3D等の希望はあるか？
4. **テキスト**: 画像内に入れたい文字はあるか？
5. **サイズ・比率**: 横長（16:9）、正方形（1:1）、縦長（9:16）等

### テキストから画像を生成する（text-to-image）

`scripts/generate_image.sh`（このスキルディレクトリ内）を使用する:

```bash
bash .agents/skills/image-generation/scripts/generate_image.sh "プロンプト" [出力ファイル名] [モデルID]
```

例:
```bash
# 基本的な画像生成（デフォルト: Nano Banana）
bash .agents/skills/image-generation/scripts/generate_image.sh "A cute cat sitting on a windowsill at sunset"

# 出力ファイル名を指定
bash .agents/skills/image-generation/scripts/generate_image.sh "東京タワーの夜景" tokyo_tower.png

# Nano Banana Pro（高品質モデル）を使用
bash .agents/skills/image-generation/scripts/generate_image.sh "商品パッケージのモックアップ" mockup.png gemini-3-pro-image-preview
```

### 画像を編集する（image-to-image）

既存の画像を参照して編集する場合は `scripts/edit_image.sh`（このスキルディレクトリ内）を使用する:

```bash
bash .agents/skills/image-generation/scripts/edit_image.sh "編集指示のプロンプト" 参照画像パス [出力ファイル名] [モデルID]
```

例:
```bash
# 画像の背景を変更
bash .agents/skills/image-generation/scripts/edit_image.sh "背景を桜並木に変更してください" input.png edited.png

# 画像に日本語テキストを追加
bash .agents/skills/image-generation/scripts/edit_image.sh "画像の上部に「春のセール開催中」と大きく追加して" product.png sale_banner.png
```

### 直接curlで呼び出す場合

スクリプトを使わず直接APIを呼ぶ場合:

```bash
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: $GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {"text": "プロンプト"}
      ]
    }],
    "generationConfig": {
      "responseModalities": ["TEXT", "IMAGE"]
    }
  }'
```

レスポンスの `candidates[0].content.parts` に `inlineData` が含まれる場合、その `data` フィールドがBase64エンコードされた画像データ。`base64 --decode` でデコードしてファイルに保存する。

---

## プロンプト作成の基本原則

効果的な画像を生成するための詳細なプロンプトガイドは [references/prompt-guide.md](references/prompt-guide.md) を参照。

### クイックリファレンス

1. **具体的に書く**: 被写体、構図、スタイル、色、雰囲気を明示する
2. **カメラ用語を使う**: 「ローアングル」「望遠レンズ」「ボケ感」「自然光」が有効
3. **日本語テキストは引用符で囲む**: `「春のセール」というテキストを大きく配置`
4. **ネガティブプロンプトも使う**: `テキストなし、ウォーターマークなし`
5. **反復で改善する**: 1回で完璧を目指さず、結果を見てプロンプトを調整する

### プロンプトの構造テンプレート

```
[被写体の詳細な説明]。
[カメラ設定: レンズ、アングル、被写界深度]。
[ライティング: 光源の種類と方向]。
[色調・雰囲気]。
[追加の指示: テキスト配置、除外要素等]
```

---

## ビジネス活用パターン

| 用途 | プロンプト例 |
|------|-------------|
| サムネイル | `YouTubeサムネイル。左に驚いた表情の人物、右に「衝撃の結果」と大きな白文字。背景はグラデーション` |
| 商品モックアップ | `白背景のミニマルな商品撮影。ガラスの香水ボトルに「SAKURA」のラベル。柔らかい影` |
| SNSバナー | `Instagram投稿用の正方形画像。カフェの写真に「GRAND OPEN」のテキストをオーバーレイ` |
| 図解 | `ビジネスフロー図。左から右に3つのステップ。各ステップにアイコンと日本語の説明文` |
| 不動産広告 | `高級マンションの外観写真。下部に「全室南向き・駅徒歩3分」のテキストバナー` |

用途別の詳細なプロンプトテンプレートは [references/prompt-guide.md](references/prompt-guide.md) を参照。

---

## 制限事項

- 生成された画像にはSynthIDの電子透かしが自動的に埋め込まれる
- 人物の生成にはセーフティフィルターが適用される場合がある
- APIにはレート制限がある（詳細は Google AI for Developers のドキュメントを参照）
- 画像編集時の参照画像はBase64エンコードして送信する必要がある

---

## トラブルシューティング

| 問題 | 対処法 |
|------|--------|
| `GEMINI_API_KEY` が未設定 | `echo $GEMINI_API_KEY` で確認。未設定なら `export GEMINI_API_KEY="your-key"` |
| 画像が生成されずテキストのみ返る | `generationConfig` に `"responseModalities": ["TEXT", "IMAGE"]` を追加 |
| セーフティフィルターでブロック | プロンプトを調整するか、`safetySettings` でしきい値を変更 |
| Base64デコードに失敗 | jqの出力に引用符が含まれていないか確認。`-r` オプションを使う |
| レスポンスが空 | APIキーの有効性とクォータを Google AI Studio で確認 |
| 日本語テキストが崩れる | テキスト量を減らす。`gemini-3-pro-image-preview` に切り替える |
| 意図と違う画像が出る | プロンプトを構造化する。ネガティブ指示を活用する |

---

## タスク固有の質問

1. どんな用途の画像ですか？（サムネイル、バナー、商品画像、SNS投稿等）
2. 画像内にテキストを入れますか？ 入れる場合、何と書きますか？
3. 写真風、イラスト風などスタイルの希望はありますか？
4. アスペクト比の指定はありますか？（16:9、1:1、9:16等）
5. 参照画像や編集したい既存画像はありますか？
6. ブランドカラーやデザインガイドラインはありますか？

---

## 関連スキル

- **copywriting**: 画像内に入れるキャッチコピーやCTA文言の作成
- **landing-page-composition**: LP向けビジュアル素材の要件確認
- **social-content**: SNS投稿用画像の企画・方針
