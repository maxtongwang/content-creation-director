#!/usr/bin/env bash
# 更新到最新版，并说清楚变了什么。
#
# 用 git 装的（Claude Code / Codex）：拉一下就生效，本脚本顺便告诉你变了什么。
# 用 .skill 装的（桌面版 / 网页 / 手机）：拉完会重新打包，你再上传一次。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

old_ver="$(cat VERSION 2>/dev/null || echo "?")"
old_sha="$(git rev-parse --short HEAD 2>/dev/null || echo "?")"

echo "当前：v${old_ver}  (${old_sha})"
echo "拉取更新..."

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo
  echo "⚠️  本地有未提交的改动，先停下。"
  echo "    你自己改过的东西会被 pull 影响，请先 commit 或 stash："
  git status --short | sed 's/^/      /'
  exit 1
fi

# 没有 upstream 时 `git pull` 直接报错退出（filter-repo 之后、
# 或手工 add remote 时都会这样），显式指定 remote/branch 更稳。
branch="$(git rev-parse --abbrev-ref HEAD)"
if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git pull --ff-only
else
  remote="$(git remote | head -1)"
  if [ -z "$remote" ]; then
    echo "没有配置 remote，无法更新。" >&2
    exit 1
  fi
  git pull --ff-only "$remote" "$branch"
  git branch --set-upstream-to="$remote/$branch" "$branch" >/dev/null 2>&1 || true
fi

new_ver="$(cat VERSION 2>/dev/null || echo "?")"
new_sha="$(git rev-parse --short HEAD)"

if [ "$old_sha" = "$new_sha" ]; then
  echo
  echo "已经是最新的 v${new_ver}，没有变化。"
  exit 0
fi

echo
echo "已更新：v${old_ver} → v${new_ver}   (${old_sha} → ${new_sha})"
echo

# 本次更新涉及的版本条目，直接从 CHANGELOG 里取
if [ "$old_ver" != "$new_ver" ] && [ -f CHANGELOG.md ]; then
  echo "── 变更 ──"
  awk -v stop="$old_ver" '
    /^## \[/ {
      ver=$0; sub(/^## \[/,"",ver); sub(/\].*/,"",ver)
      if (ver == stop) exit
    }
    /^## \[/,0 {print}
  ' CHANGELOG.md | head -60
  echo
fi

# 装在 skills 目录里（含通过 symlink）就不用再做什么
real_root="$(cd "$ROOT" && pwd -P)"
for d in "$HOME/.claude/skills"/*; do
  [ -e "$d" ] || continue
  if [ "$(cd "$d" 2>/dev/null && pwd -P)" = "$real_root" ]; then
    echo "✅ Claude Code：已生效（重开一个会话即可）"
    found_cc=1
  fi
done

echo "重新打包 .skill ..."
bash scripts/build.sh

cat <<EOF

下一步（只对用 .skill 安装的客户端）：

  桌面版 / 网页 / 手机
    Settings → Capabilities → Skills → 重新上传
    dist/content-creation-director.skill
    传一次，三端都会同步。

  ChatGPT
    Project 里替换掉旧的文件。

  Claude Code / Codex（用 git 装的）
    不用做任何事，已经生效。
EOF
