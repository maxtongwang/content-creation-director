#!/usr/bin/env bash
# 打包成可安装的 .skill 文件
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${ROOT}/dist"
NAME="director"

rm -rf "${OUT}" && mkdir -p "${OUT}/${NAME}"

cp "${ROOT}/SKILL.md" "${OUT}/${NAME}/"
cp -r "${ROOT}/workflows" "${ROOT}/references" "${ROOT}/templates" "${OUT}/${NAME}/"
cp "${ROOT}/README.md" "${OUT}/${NAME}/" 2>/dev/null || true
# 注意：archive/ 不打包 —— 那是研究笔记，不是产品的一部分

cd "${OUT}"
zip -qr "${NAME}.skill" "${NAME}"
rm -rf "${NAME}"

echo "✅ 已生成 ${OUT}/${NAME}.skill"
