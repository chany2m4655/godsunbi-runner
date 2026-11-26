# godsunbi-runner

갓선비 스튜디오(비공개 저장소 `godsunbi`)의 **GitHub Actions 실행기** — 공개 저장소라 Actions 분이 무료입니다.

- 이 저장소에는 **워크플로와 배포·산출물 스크립트만** 있습니다. 코드·대본·데이터는 비공개 `godsunbi` 에 그대로 있고,
  각 워크플로가 `PRIVATE_REPO_TOKEN` 으로 체크아웃 → 그대로 실행 → 결과를 `godsunbi` 로 다시 커밋합니다.
- 비밀값은 모두 Actions Secrets 에만 둡니다 (값은 로그에 `***` 로 가려짐).
- **공개 로그·아티팩트 보호**: 대본 원문·편 이름·Drive ID 는 로그에 찍지 않거나 마스킹합니다.
  공개 아티팩트는 만들지 않고, 음원·영상·리포트는 비공개 `godsunbi` 의 별도 브랜치(`apidub-out`, `merge-reports`, `origdl-out`, `shortsdl-out`)에 저장합니다.
- **사이트 배포**(godsunbi.pages.dev)는 `scripts/deploy.sh` 가 `scripts/deploy-exclude.txt` 에 적힌 대본 원본(`apidub/in/*.txt` 등)·코드·작업 폴더를 뺀 사본만 올립니다.

| 워크플로 | 하는 일 | 실행 |
|---|---|---|
| `hot.yml` | 떡상 수집·레이더·성과 + 배포 | 매일 KST 06·10·14·18·22시 |
| `hot-deep.yml` | 떡상 심층(자막·화풍) | 매일 KST 06:40 |
| `perf.yml` | 성과 수집 수동 백업 + 배포 | 수동 |
| `deploy.yml` | godsunbi.pages.dev 배포 | 수동 |
| `merge.yml` | 스튜디오 #merge 탭 합치기 | 스튜디오가 dispatch |
| `apidub.yml` | API 더빙 (⚠ 유료 키) | 수동, 허락 후에만 |
| 그 밖 | hot-fast · studio · linetest · voice-samples · narr-audition · whisper-check · lipsync-run · origdl · origprobe · shortsdl · perf-worker · subs-worker | 수동 |
