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

cd "${OUT}"
zip -qr "${NAME}.skill" "${NAME}"
rm -rf "${NAME}"

echo "✅ 已生成 ${OUT}/${NAME}.skill"
