#!/usr/bin/env bash
# 산출물(음원·영상·리포트)을 공개 아티팩트 대신 비공개 godsunbi 저장소의 별도 브랜치에 올린다.
# 사용: GH_PAT=... push_out.sh <브랜치> <원본폴더> <대상하위폴더>
set -euo pipefail
BR="$1"; SRC="$2"; DEST="$3"
if [ ! -d "$SRC" ] || [ -z "$(ls -A "$SRC" 2>/dev/null)" ]; then echo "산출물 없음 — 건너뜀"; exit 0; fi
: "${GH_PAT:?GH_PAT 필요}"
URL="https://x-access-token:${GH_PAT}@github.com/chany2m4655/godsunbi.git"
W="${RUNNER_TEMP:-/tmp}/out-$BR"; rm -rf "$W"
if git ls-remote --exit-code --heads "$URL" "$BR" >/dev/null 2>&1; then
  git clone -q --depth 1 --branch "$BR" "$URL" "$W"
else
  git init -q "$W"; git -C "$W" checkout -q --orphan "$BR"; git -C "$W" remote add origin "$URL"
fi
mkdir -p "$W/$DEST"; cp -r "$SRC"/. "$W/$DEST/"
# GitHub 100MB 제한: 95MB 넘는 파일은 90MB 조각으로 (cat f.part* > f 로 복원)
find "$W/$DEST" -type f -size +95M -print0 | while IFS= read -r -d '' f; do split -b 90m -d "$f" "$f.part"; rm -f "$f"; done
cd "$W"
git config user.name "godsunbi-runner"; git config user.email "6102799+chany2m4655@users.noreply.github.com"
git add -A
git diff --cached --quiet && { echo "변경 없음"; exit 0; }
git commit -q -m "산출물 run ${GITHUB_RUN_ID:-local}"
for i in 1 2 3; do
  git push -q origin "HEAD:$BR" && { echo "비공개 저장소 브랜치 $BR 에 저장 완료 ($(find "$DEST" -type f | wc -l)개)"; exit 0; }
  git pull -q --rebase origin "$BR" || true; sleep 5
done
echo "::error::push 실패(3회)"; exit 1
