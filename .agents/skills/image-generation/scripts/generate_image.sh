#!/bin/bash
# =============================================================================
# Nano Banana Pro / Nano Banana — テキストから画像を生成するスクリプト
#
# 使い方:
#   bash generate_image.sh "プロンプト" [出力ファイル名] [モデルID]
#
# 引数:
#   $1 — プロンプト（必須）
#   $2 — 出力ファイル名（省略時: generated_image.png）
#   $3 — モデルID（省略時: gemini-2.5-flash-image）
#         高品質版: gemini-3-pro-image-preview
#
# 前提:
#   - 環境変数 GEMINI_API_KEY が設定されていること
#   - curl, jq, base64 コマンドが使用可能であること
# =============================================================================

set -euo pipefail

# --- 引数の処理 ---
PROMPT="${1:?エラー: プロンプトを第1引数に指定してください}"
OUTPUT_FILE="${2:-generated_image.png}"
MODEL="${3:-gemini-2.5-flash-image}"

# --- APIキーの確認 ---
if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "エラー: 環境変数 GEMINI_API_KEY が設定されていません。" >&2
  echo "  export GEMINI_API_KEY=\"your-api-key-here\"" >&2
  exit 1
fi

# --- 依存コマンドの確認 ---
for cmd in curl jq base64; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "エラー: $cmd コマンドが見つかりません。インストールしてください。" >&2
    exit 1
  fi
done

API_URL="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"

echo "🍌 Nano Banana 画像生成中..."
echo "   モデル: ${MODEL}"
echo "   プロンプト: ${PROMPT}"

# --- APIリクエスト ---
RESPONSE=$(curl -s -X POST "${API_URL}" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg prompt "$PROMPT" \
    '{
      contents: [{
        parts: [
          { text: $prompt }
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

# --- レスポンスからテキストと画像を抽出 ---
PARTS_COUNT=$(echo "$RESPONSE" | jq '.candidates[0].content.parts | length')

if [ "$PARTS_COUNT" = "null" ] || [ "$PARTS_COUNT" = "0" ]; then
  echo "❌ レスポンスにパーツが含まれていません。" >&2
  echo "   セーフティフィルターでブロックされた可能性があります。" >&2
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
    echo "✅ 画像を保存しました: ${OUTPUT_FILE}"
  fi
done

if [ "$IMAGE_SAVED" = false ]; then
  echo ""
  echo "⚠️  画像が生成されませんでした。テキストのみのレスポンスです。" >&2
  echo "   プロンプトを調整するか、モデルを変更してみてください。" >&2
  exit 1
fi
