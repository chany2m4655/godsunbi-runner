#!/usr/bin/env python3
"""배포용 사본 만들기: stage.py <원본> <대상> <제외목록>
제외목록 한 줄 = 패턴. '/'로 시작하면 저장소 루트 기준 경로(fnmatch), 아니면 파일·폴더 이름(fnmatch).
폴더가 제외되면 그 아래 전부 제외. '#' 줄은 주석."""
import fnmatch, os, shutil, sys
src, dst, lst = sys.argv[1:4]
pats = [l.strip() for l in open(lst, encoding="utf-8") if l.strip() and not l.lstrip().startswith("#")]
def excluded(rel):
    base = os.path.basename(rel)
    for p in pats:
        if p.startswith("/"):
            if fnmatch.fnmatchcase(rel, p[1:]): return True
        elif fnmatch.fnmatchcase(base, p): return True
    return False
n = skipped = 0
for root, dirs, files in os.walk(src):
    r = os.path.relpath(root, src); r = "" if r == "." else r
    keep = []
    for d in dirs:
        rel = os.path.join(r, d) if r else d
        if excluded(rel): skipped += 1
        else: keep.append(d)
    dirs[:] = keep
    for f in files:
        rel = os.path.join(r, f) if r else f
        if excluded(rel): skipped += 1; continue
        out = os.path.join(dst, rel); os.makedirs(os.path.dirname(out), exist_ok=True)
        try: os.link(os.path.join(root, f), out)   # 같은 디스크면 하드링크(빠름)
        except OSError: shutil.copy2(os.path.join(root, f), out)
        n += 1
print(f"배포 파일 {n}개 (제외 항목 {skipped}개)")
