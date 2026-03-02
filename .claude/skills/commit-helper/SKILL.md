---
name: commit-helper
description: staged 변경사항 기준 커밋 메시지 자동 생성. "커밋", "commit", "커밋 메시지" 입력 시 사용.
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git status:*)
metadata:

  version: 1.1.0
  category: development
  priority: medium
---

# Commit Message Generator

staged 변경사항을 분석하여 프로젝트 컨벤션에 맞는 커밋 메시지 자동 생성

## 기본 원칙

- 반드시 `git diff --staged` 기준
- 타입 프리픽스는 **무조건 영어** (`feat`, `fix`, `chore` 등)
- 요약 50자 이내
- 동사 현재형 (추가, 수정, 개선)
- 결과 중심 작성

## 실행 플로우

### 1. 컨벤션 감지

```bash
git log --oneline --format="%s" -20
```

**확인 항목:**

- Conventional Commits 여부 (feat:, fix:)
- scope 사용 패턴
- Body 사용 빈도

**감지 결과 적용:**

| 감지 결과 | 적용 방식 |
|-----------|-----------|
| scope 없는 패턴 다수 | scope 생략 우선 |
| Body 없는 패턴 다수 | 간결 옵션 권장 |
| 커밋 이력 없음 | Conventional Commits 기본 적용 |

타입 프리픽스는 이력과 무관하게 항상 영어 사용.

### 2. 변경사항 분석

```bash
git diff --staged --stat --name-status
git diff --staged
```

**체크 포인트:**

- 변경 파일 수
- 변경 영역 (apps/, packages/, services/)
- rename/move 포함 여부
- 설정 파일 변경 여부

### 3. 타입 결정

**기능:**

- `feat` → 새 기능
- `fix` → 버그 수정
- `perf` → 성능 개선

**구조:**

- `refactor` → 구조 개선
- `test` → 테스트 추가
- `docs` → 문서 변경
- `style` → 포맷, 세미콜론 등 로직 무관 변경
- `chore` → 의존성, 기타 잡무
- `build` → 빌드 시스템, 패키지 설정 변경
- `ci` → CI/CD 파이프라인 설정 변경

### 4. Scope 추론

**모노레포 (apps/, packages/, services/ 등 워크스페이스 구조):**

```
apps/web/...            → (web)
apps/admin/...          → (admin)
services/auth/...       → (auth)
services/trade-executor/... → (trade-executor)
packages/ui/...         → (ui)
packages/risk-engine/...    → (risk-engine)
packages/utils/...      → (utils)
```

폴더 이름 전체가 아닌 **패키지명 핵심 부분**만 사용:
- `packages/shared-components` → `(shared-components)` 또는 `(components)`
- `services/notification-service` → `(notification)` 또는 `(notification-service)`
- `apps/mobile-app` → `(mobile)` 또는 `(mobile-app)`

**단일 레포 (모노레포 아닌 경우):**

```
src/components/... → (component) 또는 scope 생략
src/api/users/...  → (users) 또는 (api)
src/auth/...       → (auth)
```

단일 레포에서는 scope가 없어도 무방하며, 변경 범위가 명확할 때만 사용.

**여러 영역 변경 시:**

- 주요 변경 영역 우선
- 애매하면 scope 생략

### 5. Body 포함 조건

다음 중 하나 이상:

- ✅ 파일 5개 이상, 또는 여러 영역에 걸친 변경
- ✅ rename/move 포함
- ✅ 설정/의존성 변경
- ✅ 리스크 영역 (거래, 인증, DB)
- ✅ 변경 이유 설명 필요

### 6. Breaking Change

다음 시 `BREAKING CHANGE` 명시:

- DB 스키마 변경
- 환경변수 키 변경
- 공개 API 시그니처 변경

## 출력 형식

### Option 1: 기본 (권장)

```
{type}({scope}): {요약}

- 변경사항 1
- 변경사항 2
```

### Option 2: 간결

```
{type}({scope}): {요약}
```

### Option 3: 상세

```
{type}({scope}): {요약}

- 상세 변경사항 1
- 상세 변경사항 2
- 변경 이유
```

## 예외 처리

### staged 없음

```
❌ No staged changes. Use `git add` first.
```

### lockfile만

```
chore(deps): lockfile 업데이트
```

### 대량 파일 (100개+)

```
⚠️ 100개 이상 변경. 커밋 분리 권장.
```

### 리네임 중심

```
refactor: {before} → {after} 리네임
```

---

**사용 예시:**

모노레포 (scope 있는 경우):
```
사용자: "커밋 메시지 만들어줘"

Claude: (컨벤션 감지 → 영어/scope 사용 패턴 확인)

## 🎯 권장 커밋 메시지

### Option 1: 기본 (권장)
feat(web): 사용자 대시보드 추가

- 실시간 차트 컴포넌트 구현
- API 연동 완료

### Option 2: 간결
feat(web): 사용자 대시보드 추가

### Option 3: 상세
feat(web): 사용자 대시보드 추가

- 실시간 차트 컴포넌트 구현 (Recharts)
- REST API 연동 (/api/user/dashboard)
- 반응형 레이아웃 (Tailwind)
- 로딩 상태 관리 (React Query)

변경 이유: 사용자 요청사항 반영
```

단일 레포 (scope 생략):
```
사용자: "커밋 메시지 만들어줘"

Claude: (컨벤션 감지 → scope 없는 패턴 확인)

## 🎯 권장 커밋 메시지

### Option 1: 기본 (권장)
feat: 로그인 폼 유효성 검사 추가

- 이메일 형식 검증
- 비밀번호 최소 길이 적용

### Option 2: 간결
feat: 로그인 폼 유효성 검사 추가
```
