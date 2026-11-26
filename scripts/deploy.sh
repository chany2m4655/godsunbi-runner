#!/usr/bin/env bash
# godsunbi(비공개) 체크아웃을 Cloudflare Pages 'godsunbi' 에 배포한다.
# 저장소 전체가 아니라 deploy-exclude.txt 에 적힌 초안·대본·코드를 뺀 사본만 올린다.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-$GITHUB_WORKSPACE}"
if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then echo "::error::secret CLOUDFLARE_API_TOKEN 이 없습니다"; exit 1; fi
( cd "$SRC" && python3 apidub/plan.py >/dev/null 2>&1 || true )   # TTS 페이지용 plan.json 갱신(출력 비공개)
STAGE="${RUNNER_TEMP:-/tmp}/godsunbi-site"
rm -rf "$STAGE"
python3 "$HERE/stage.py" "$SRC" "$STAGE" "$HERE/deploy-exclude.txt"
cd "$STAGE"   # functions/ 가 여기 있어야 Pages Functions 도 함께 배포됨
npx -y wrangler@4 pages deploy . --project-name godsunbi --branch main --commit-dirty=true
