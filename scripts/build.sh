#!/usr/bin/env bash
# 打包成可安装的 .skill 文件
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${ROOT}/dist"
NAME="content-creation-director"

rm -rf "${OUT}" && mkdir -p "${OUT}/${NAME}"

cp "${ROOT}/SKILL.md" "${OUT}/${NAME}/"
cp -r "${ROOT}/workflows" "${ROOT}/references" "${ROOT}/templates" "${OUT}/${NAME}/"
# automation/ 要打包 —— 7-review 的配额诊断、3-topic 的闸门都依赖它
cp -r "${ROOT}/automation" "${OUT}/${NAME}/"
mkdir -p "${OUT}/${NAME}/docs"
cp "${ROOT}/docs/sync-notes.md" "${OUT}/${NAME}/docs/"
cp "${ROOT}/README.md" "${OUT}/${NAME}/" 2>/dev/null || true
# archive/ 与 docs/architecture.md 不打包 —— 研究笔记与仓库文档，不是运行时依赖

cd "${OUT}"
zip -qr "${NAME}.skill" "${NAME}"
rm -rf "${NAME}"

echo "✅ 已生成 ${OUT}/${NAME}.skill"
