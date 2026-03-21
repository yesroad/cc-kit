# claude_kit

범용 AI 코딩 툴킷 — Claude Code, Cursor, OpenCode, Codex에서 동일한 규칙·에이전트·스킬을 사용합니다.

---

## 지원 툴

| 툴          | 설치 옵션    | 설치 경로                                                                               |
| ----------- | ------------ | --------------------------------------------------------------------------------------- |
| Claude Code | `--claude`   | `.claude/`                                                                              |
| Cursor      | `--cursor`   | `.cursor/` + `.agents/skills/`                                                          |
| OpenCode    | `--opencode` | `.opencode/` + `AGENTS.md`                                                              |
| Codex       | `--codex`    | `src/` 마이그레이션 후 `AGENTS.md` + `.codex/` + `.agents/skills/` + `.codex/AGENTS.md` |

---

## 사전 요구사항

일부 기능은 아래 도구를 필요로 합니다:

```bash
# Bun (plugins/notify.js가 Bun 전용 import 사용)
curl -fsSL https://bun.sh/install | bash

# terminal-notifier (macOS 작업 완료 알림)
brew install terminal-notifier

# gh CLI (PR 생성 및 리뷰 조회)
brew install gh
gh auth login
```

---

## 설치

### 방법 1 — `/setup` 커맨드 (Claude Code Plugin, 권장)

Claude Code에서 claude_kit 플러그인을 통해 `/claude_kit:setup`을 실행합니다.

기술 스택 인터뷰(프레임워크·스타일링·상태 관리 5문항)를 진행한 후 **프로젝트에 맞춤화된** CLAUDE.md와 `.claude/` 설정을 자동 생성합니다.

| 조건 | 포함되는 스킬 |
|------|--------------|
| 항상 | `commit-helper`, `pr-review-responder`, `code-quality`, `refactor`, `bug-fix`, `migration-helper`, `test-generator` |
| Next.js | `next-project-structure` 추가 |
| Next.js 또는 React | `component-creator` 추가 |
| Next.js 또는 React + TailwindCSS | `web-design` 추가 |

설치 시 `.mcp.json` 템플릿도 함께 복사됩니다 (기존 파일이 없을 때만). API 키는 직접 설정해야 합니다.

### 방법 2 — 원격 스크립트

프로젝트 루트에서 한 줄로 실행합니다. 레포를 `~/.config/claude_kit/`에 자동으로 clone합니다.

```bash
# Claude Code
curl -fsSL https://raw.githubusercontent.com/yesroad/claude_kit/main/install.sh \
  | bash -s -- --claude .

# Cursor
curl -fsSL https://raw.githubusercontent.com/yesroad/claude_kit/main/install.sh \
  | bash -s -- --cursor .

# Codex
curl -fsSL https://raw.githubusercontent.com/yesroad/claude_kit/main/install.sh \
  | bash -s -- --codex .

# OpenCode
curl -fsSL https://raw.githubusercontent.com/yesroad/claude_kit/main/install.sh \
  | bash -s -- --opencode .

# 전체 (4개 모두)
curl -fsSL https://raw.githubusercontent.com/yesroad/claude_kit/main/install.sh \
  | bash -s -- --all .
```

두 번째 실행부터는 캐시를 최신 상태로 동기화(`git fetch + reset --hard`)한 뒤 설치합니다.

### 방법 3 — 로컬

```bash
git clone https://github.com/yesroad/claude_kit.git
cd claude_kit

# 단일 툴
./install.sh --claude   /path/to/your-project
./install.sh --cursor   /path/to/your-project
./install.sh --opencode /path/to/your-project
./install.sh --codex    /path/to/your-project

# 전체 (4개 모두)
./install.sh --all /path/to/your-project
```

설치 시 툴별로 필요한 파일만 복사됩니다. Cursor, Codex는 스킬을 `.agents/skills/`에 따로 설치하고, OpenCode는 `.opencode/AGENTS.md`, Codex는 루트 `AGENTS.md`와 `.codex/AGENTS.md`가 함께 생성되어 어떤 파일을 언제 참조할지 안내합니다. Codex는 설치 전에 `src/`의 Claude 전용 문법을 `.build/codex-src/`로 마이그레이션한 뒤 설치합니다.

---

## 디렉토리 구조

```
claude_kit/
├── rules/core/             # 코딩 규칙
│   ├── thinking-model.md           # 통합 사고 모델 (READ→REACT→ANALYZE→...)
│   ├── coding-standards.md         # TypeScript 표준, 에러 처리, React 패턴
│   ├── react-nextjs-conventions.md # React/Next.js 컨벤션, Import 순서
│   ├── react-hooks-patterns.md     # Hook 성능 패턴 (useMemo, useRef 등)
│   ├── nextjs-app-router.md        # App Router 전용 규칙
│   ├── state-and-server-state.md   # TanStack Query v5 + Jotai 상태 경계
│   ├── unit-test-conventions.md    # 순수 함수 유닛 테스트 규칙
│   ├── accessibility.md            # WCAG 2.1 AA 접근성 규칙
│   ├── pr-guide.md                 # PR 작성 가이드
│   └── policy-definitions.md       # 정책(Policy) 정의 기준
│
├── agents/                 # 전문화된 서브에이전트
│   ├── explore.md                  # 코드베이스 탐색
│   ├── lint-fixer.md               # 린트/타입 오류 자동 수정
│   ├── git-operator.md             # git 상태 확인, 커밋, PR 관리
│   ├── implementation-executor.md  # 계획 기반 코드 구현
│   └── code-reviewer.md            # 코드 품질·규칙 준수 검토
│
├── skills/                 # 복잡한 다단계 작업 스킬
│   ├── commit-helper/      # 커밋 메시지 자동 생성 (Conventional Commits)
│   ├── code-quality/       # 린트·포맷·타입체크 통합 실행
│   ├── bug-fix/            # 버그 분석·수정 (2-3가지 옵션 제시)
│   ├── refactor/           # 코드 리팩토링 분석 및 단계별 실행
│   ├── component-creator/  # 프로젝트 패턴 학습 후 컴포넌트/훅 생성 (React/Next.js)
│   ├── next-project-structure/ # Next.js 도메인 전체 스캐폴딩
│   ├── web-design/         # Next.js + TailwindCSS + shadcn/ui UI 구현
│   ├── test-generator/     # 테스트 케이스 생성 및 커버리지 리포트
│   ├── pr-review-responder/# PR 리뷰 코멘트 분류 및 자동 반영
│   ├── migration-helper/   # 라이브러리 버전 업그레이드 및 패턴 마이그레이션
│   ├── docs-creator/       # CLAUDE.md·SKILL.md·AGENTS.md 문서 작성
│   └── agents-generator/   # 프로젝트 분석 후 루트 지시문 자동 생성
│
├── commands/               # 슬래시 커맨드
│   ├── setup.md            # 프로젝트 맞춤 설치 (기술 스택 인터뷰 → CLAUDE.md 생성)
│   ├── start.md            # 작업 시작: 분석 → 계획 → 확인
│   ├── done.md             # 작업 완료: 검증 → 커밋 → PR
│   ├── commit.md           # staged 변경사항으로 커밋 메시지 생성 후 커밋
│   ├── quality.md          # 포맷 → 린트 → 타입 체크 순서로 실행
│   └── setup-notifier.md   # 초기 환경 설정 (macOS terminal-notifier)
│
├── instructions/           # 작업 방식·검증 가이드
│   ├── multi-agent/        # 멀티 에이전트 협업 패턴 (coordination-guide, model-routing)
│   ├── validation/         # 금지 패턴, 필수 행동
│   └── workflow-patterns/  # 복잡도별 작업 단계
│
├── hooks/                  # 이벤트 훅
│   └── notify.sh           # macOS 알림 (terminal-notifier)
│
├── plugins/                # OpenCode 전용 플러그인
│   └── notify.js           # permission.asked 이벤트 알림
│
└── .mcp.json               # MCP 서버 설정 템플릿 (Figma, Supabase, Playwright 등)
```

---

## 툴별 복사 매트릭스

각 툴에 맞는 파일만 복사되며, 비호환 필드는 자동으로 변환됩니다.

| 디렉토리        |        Claude        |        Cursor        |        OpenCode        |        Codex         |
| --------------- | :------------------: | :------------------: | :--------------------: | :------------------: |
| `hooks/`        |          ✅          |          ✅          |           ❌           |          ❌          |
| `plugins/`      |          ❌          |          ❌          |           ✅           |          ❌          |
| `agents/`       |       ✅ 원본        |       ✅ 원본        |        ✅ 변환         |       ✅ 변환        |
| `rules/`        |          ✅          |          ✅          |           ✅           |          ✅          |
| `skills/`       | ✅ `.claude/skills/` | ✅ `.agents/skills/` | ✅ `.opencode/skills/` | ✅ `.agents/skills/` |
| `commands/`     |          ✅          |          ✅          |           ✅           |          ✅          |
| `settings.json` |          ✅          |          ❌          |           ❌           |          ❌          |

> **agents/ 변환 내용**
>
> - OpenCode: `tools:`, `model:`, `@../` 라인 제거 (파싱 에러 방지)
> - Codex: `Task(...)`, `.claude/...`, `tools:`, `model:`, `allowed-tools:` 등 Claude 전용 표현을 Codex용 문서로 마이그레이션

---

## Codex 개발 흐름

Codex 설치는 루트 `install.sh`가 아래 내부 파이프라인을 호출합니다.

```bash
scripts/codex/build.sh
scripts/codex/verify.sh
scripts/codex/install.sh /path/to/your-project
```

- `build.sh`: 루트 디렉토리를 `.build/codex-src/`로 변환
- `verify.sh`: Claude 전용 패턴 잔존 여부 검사
- `install.sh`: 검증된 산출물을 `.codex/`와 `.agents/skills/`로 설치

---

## 주요 기능

### 멀티 에이전트 병렬 실행

독립적인 작업을 동시에 여러 에이전트에 위임해 속도를 높입니다.

```
복잡도별 모델 라우팅:
- LOW  → haiku  (빠르고 저렴)
- MED  → sonnet (균형)
- HIGH → opus   (최고 품질)
```

### Skills & Commands

#### 커맨드 (직접 호출)

| 커맨드            | 설명                                                           |
| ----------------- | -------------------------------------------------------------- |
| `/setup`          | 기술 스택 인터뷰 → 맞춤형 CLAUDE.md + `.claude/` 설치         |
| `/start`          | 작업 시작 — 분석 → 계획 수립 → 구현 확인                       |
| `/done`           | 작업 완료 — 검증 → 테스트 → 커밋 → PR                          |
| `/commit`         | staged 변경사항 분석 후 커밋 메시지 생성 및 커밋               |
| `/quality`        | 포맷 → 린트 → 타입 체크 순서로 실행 및 자동 수정               |
| `/setup-notifier` | macOS 알림 초기 환경 설정 (최초 1회)                           |

#### 스킬 (자동 트리거)

| 스킬                    | 트리거                              | 설명                                             | 조건 |
| ----------------------- | ----------------------------------- | ------------------------------------------------ | ---- |
| `commit-helper`         | "커밋 메시지 만들어줘"              | staged 변경사항 기반 커밋 메시지 자동 생성       | 항상 |
| `code-quality`          | "린트", "포맷", "타입체크"          | 린트·포맷·타입체크 통합 실행                     | 항상 |
| `bug-fix`               | "버그", "오류", "에러"              | 버그 원인 분석 후 2-3가지 해결 옵션 제시         | 항상 |
| `refactor`              | "리팩토링", "구조 개선"             | 정책 보호 테스트 포함 단계별 리팩토링            | 항상 |
| `test-generator`        | "테스트 작성", "커버리지 올려"      | 테스트 케이스 생성 + 커버리지 리포트             | 항상 |
| `pr-review-responder`   | "리뷰 반영", PR 번호/URL            | 리뷰 코멘트 수용/거절/질문 분류 후 자동 반영     | 항상 |
| `migration-helper`      | "업그레이드", "마이그레이션"        | 라이브러리 버전 업그레이드 단계적 실행           | 항상 |
| `docs-creator`          | "문서 작성", "CLAUDE.md"            | AI 코딩 도구용 문서 작성                         | 항상 |
| `agents-generator`      | "루트 지시문 생성"                  | 프로젝트 분석 후 CLAUDE.md/AGENTS.md 생성        | 항상 |
| `component-creator`     | "컴포넌트 만들어", "페이지 추가"    | 프로젝트 패턴 학습 후 일관된 보일러플레이트 생성 | React / Next.js |
| `next-project-structure`| "도메인 추가", "서비스 파일 만들어" | service + query 훅 + view 전체 스캐폴딩          | Next.js |
| `web-design`            | "UI 만들어", "화면 구현해줘"        | 2025 트렌드 UI를 shadcn/ui로 구현                | Next.js + TailwindCSS |

### 전형적인 개발 사이클

```
/setup              → 기술 스택 인터뷰 + 맞춤형 CLAUDE.md 생성 (최초 1회)
  ↓
/start              → 작업 분석 + 계획 수립
  ↓ 구현
component-creator   → 새 컴포넌트/훅 생성 (프로젝트 패턴 자동 적용)
bug-fix             → 버그 발견 시 원인 분석 + 옵션 제시
refactor            → 구조 개선 필요 시
test-generator      → 테스트 작성 + 커버리지 확인
  ↓
/quality            → 포맷 → 린트 → 타입 체크 자동 수정
/done               → 검증 → 커밋 → PR (통합 완료 플로우)
  ↓ PR 리뷰 후
pr-review-responder → 리뷰 코멘트 반영
```

### 통합 사고 모델

모든 코드 작성 시 자동으로 적용되는 절차:

```
READ → REACT → ANALYZE → RESTRUCTURE → STRUCTURE → REFLECT
```

- **LOW** (1파일, 명확한 수정): READ → REACT
- **MEDIUM** (2~5파일, 기존 패턴): READ → ANALYZE → STRUCTURE → REFLECT
- **HIGH** (5파일+, 새 아키텍처): 전체 6단계 + Plan 에이전트

---

## MCP 서버 템플릿

`.mcp.json`에 Figma, Supabase, Playwright, Atlassian MCP 서버 설정 템플릿이 포함되어 있습니다.
`/setup` 실행 시 프로젝트에 자동 복사됩니다 (기존 `.mcp.json`이 없을 때만).

```json
{
  "mcpServers": {
    "Figma": { "...": "YOUR_FIGMA_API_KEY 설정 필요" },
    "supabase": { "...": "YOUR_SUPABASE_API_KEY 설정 필요" },
    "playwright": { "...": "설정 불필요" },
    "Atlassian": { "...": "JIRA/Confluence API 키 설정 필요" }
  }
}
```

---

## 지원 기술 스택

`/setup` 커맨드가 아래 스택 조합을 자동으로 감지하여 맞춤 설정을 생성합니다.

| 프레임워크 | 스타일링 | 서버 상태 | 전역 상태 |
|-----------|---------|----------|----------|
| Next.js (App / Pages Router) | TailwindCSS | TanStack Query | Jotai |
| React (CRA / Vite) | Emotion | SWR | Zustand |
| Vue | CSS Modules | 없음 | Redux Toolkit |
| 기타 | 기타 | | 없음 |

