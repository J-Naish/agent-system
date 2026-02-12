#!/bin/bash
# =============================================================================
# Nano Banana Pro / Nano Banana — 既存画像を参照して編集するスクリプト
#
# 使い方:
#   bash edit_image.sh "編集指示" 参照画像パス [出力ファイル名] [モデルID]
#
# 引数:
#   $1 — 編集指示のプロンプト（必須）
#   $2 — 参照画像のファイルパス（必須。png/jpeg/webp対応）
#   $3 — 出力ファイル名（省略時: edited_image.png）
#   $4 — モデルID（省略時: gemini-2.5-flash-image）
#
# 前提:
#   - 環境変数 GEMINI_API_KEY が設定されていること
#   - curl, jq, base64 コマンドが使用可能であること
# =============================================================================

set -euo pipefail

# --- 引数の処理 ---
PROMPT="${1:?エラー: 編集指示のプロンプトを第1引数に指定してください}"
INPUT_IMAGE="${2:?エラー: 参照画像のパスを第2引数に指定してください}"
OUTPUT_FILE="${3:-edited_image.png}"
MODEL="${4:-gemini-2.5-flash-image}"

# --- APIキーの確認 ---
if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "エラー: 環境変数 GEMINI_API_KEY が設定されていません。" >&2
  exit 1
fi

# --- 入力画像の確認 ---
if [ ! -f "$INPUT_IMAGE" ]; then
  echo "エラー: 参照画像が見つかりません: ${INPUT_IMAGE}" >&2
  exit 1
fi

# --- 依存コマンドの確認 ---
for cmd in curl jq base64; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "エラー: $cmd コマンドが見つかりません。" >&2
    exit 1
  fi
done

# --- MIMEタイプの判定 ---
EXTENSION="${INPUT_IMAGE##*.}"
case "${EXTENSION,,}" in
  png)  MIME_TYPE="image/png" ;;
  jpg|jpeg) MIME_TYPE="image/jpeg" ;;
  webp) MIME_TYPE="image/webp" ;;
  gif)  MIME_TYPE="image/gif" ;;
  *)
    echo "エラー: 未対応の画像形式です: .${EXTENSION}" >&2
    echo "  対応形式: png, jpg, jpeg, webp, gif" >&2
    exit 1
    ;;
esac

API_URL="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"

echo "🍌 Nano Banana 画像編集中..."
echo "   モデル: ${MODEL}"
echo "   参照画像: ${INPUT_IMAGE} (${MIME_TYPE})"
echo "   編集指示: ${PROMPT}"

# --- 画像をBase64エンコード ---
IMAGE_BASE64=$(base64 -w 0 "$INPUT_IMAGE" 2>/dev/null || base64 -i "$INPUT_IMAGE")

# --- APIリクエスト ---
RESPONSE=$(curl -s -X POST "${API_URL}" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg prompt "$PROMPT" \
    --arg mime "$MIME_TYPE" \
    --arg imgdata "$IMAGE_BASE64" \
    '{
      contents: [{
        parts: [
          { text: $prompt },
          {
            inlineData: {
              mimeType: $mime,
              data: $imgdata
            }
          }
        ]
      }],
      generationConfig: {
        responseModalities: ["TEXT", "IMAGE"]
      }
    }'
  )"
)

# --- エラーチェック ---
ERROR=$(echo "$RESPONSE" | jq -r '.error.message // empty')
if [ -n "$ERROR" ]; then
  echo "❌ APIエラー: ${ERROR}" >&2
  exit 1
fi

# --- レスポンスから画像を抽出 ---
PARTS_COUNT=$(echo "$RESPONSE" | jq '.candidates[0].content.parts | length')

if [ "$PARTS_COUNT" = "null" ] || [ "$PARTS_COUNT" = "0" ]; then
  echo "❌ レスポンスにパーツが含まれていません。" >&2
  echo "$RESPONSE" | jq '.promptFeedback // .candidates[0].finishReason // .' >&2
  exit 1
fi

IMAGE_SAVED=false

for i in $(seq 0 $((PARTS_COUNT - 1))); do
  PART_TEXT=$(echo "$RESPONSE" | jq -r ".candidates[0].content.parts[$i].text // empty")
  PART_IMAGE=$(echo "$RESPONSE" | jq -r ".candidates[0].content.parts[$i].inlineData.data // empty")

  if [ -n "$PART_TEXT" ]; then
    echo ""
    echo "📝 モデルからのテキスト:"
    echo "   ${PART_TEXT}"
  fi

  if [ -n "$PART_IMAGE" ]; then
    echo "$PART_IMAGE" | base64 --decode > "${OUTPUT_FILE}"
    IMAGE_SAVED=true
    echo ""
    echo "✅ 編集画像を保存しました: ${OUTPUT_FILE}"
  fi
done

if [ "$IMAGE_SAVED" = false ]; then
  echo "⚠️  画像が生成されませんでした。" >&2
  exit 1
fi
