# 에러 복구 가이드

> 워크플로우 실행 중 실패 시 복구 절차

---

## 병렬 에이전트 실패

| 상황 | 대응 |
|------|------|
| 일부 에이전트 실패 | 성공한 결과만 활용, 실패 작업 재시도 |
| 전체 에이전트 실패 | 원인 분석 후 순차 실행으로 전환 |
| 타임아웃 | 작업 범위 축소 후 재시도 |

```bash
# 에이전트 실패 원인 파악
# 1. 파일 접근 오류 → 경로 확인
# 2. 린트/빌드 오류 → 기존 코드 상태 확인
# 3. 컨텍스트 초과 → 작업 분할
```

---

## /commit 플로우 실패

### 머지 충돌

```bash
# 1. 충돌 파일 확인
git status

# 2. 충돌 해결 (수동)
# 충돌 마커 (<<<<<<< / ======= / >>>>>>>) 제거 후 올바른 코드 선택

# 3. 해결 후 계속
git add {충돌 해결된 파일}
git merge --continue
```

### 푸시 실패 (원격 변경)

```bash
# 1. 원격 변경 가져오기
git pull origin <브랜치> --rebase

# 2. 충돌 있으면 해결 후
git rebase --continue

# 3. 재푸시
git push origin <브랜치>
```

### staged 변경 유실

```bash
# git stash에서 복구
git stash list
git stash pop

# 또는 reflog에서 복구
git reflog
git checkout <커밋해시> -- <파일경로>
```

---

## /done 플로우 중단 후 재개

| 중단 시점 | 재개 방법 |
|-----------|----------|
| 테스트 실패 | 오류 수정 후 `/done` 재실행 |
| 린트/타입 체크 실패 | `lint-fixer` 에이전트로 수정 후 `/done` 재실행 |
| 커밋 후 PR 생성 실패 | `gh auth status` 확인 → `gh pr create` 수동 실행 |
| 게이트 FAIL | FAIL 항목 수정 후 `/done` 재실행 |

---

## 빌드 실패 후 부분 롤백

```bash
# 1. 마지막 정상 커밋 확인
git log --oneline -5

# 2. 특정 파일만 되돌리기 (전체 롤백 아님)
git checkout <정상커밋> -- <문제파일>

# 3. 수정 후 재빌드
{패키지매니저} build
```

> **주의**: `git reset --hard`는 모든 변경을 잃으므로 사용자 확인 없이 실행하지 않는다.

---

## 참조 문서

| 문서 | 용도 |
|------|------|
| `../multi-agent/coordination-guide.md` | 병렬 실행 원칙 |
| `../../commands/commit.md` | /commit 플로우 |
| `../../commands/done.md` | /done 플로우 |
