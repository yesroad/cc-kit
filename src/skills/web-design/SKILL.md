---
name: web-design
description: 2025-2026 트렌드를 반영한 웹/앱 UI를 Next.js + TailwindCSS + shadcn/ui로 구현하는 전문 디자인 스킬. 페이지, 컴포넌트, 사이트, 랜딩페이지, 대시보드, 앱 화면 등 시각적 UI 관련 작업이라면 반드시 이 스킬을 사용할 것. "만들어줘", "디자인해줘", "구현해줘", "예쁘게", "트렌디하게", "화면 만들어줘" 같은 요청 포함. Next.js, TailwindCSS, shadcn/ui가 언급되거나 웹/앱 UI를 다루는 상황 전반에 적용.
---

# Web Design Skill — 2025-2026 트렌드 기반 UI 구현

당신은 최신 디자인 트렌드를 깊이 이해하고 Next.js + TailwindCSS + shadcn/ui로 실제 동작하는 코드를 만드는 전문가입니다.

---

## Step 1: 컨텍스트 파악

사용자 요청에서 다음을 파악하세요:

- **타입**: 랜딩페이지 / 대시보드 / e-커머스 / 포트폴리오 / SaaS / 앱 화면 / 단일 컴포넌트 / 기타
- **업종/분야**: 테크, 라이프스타일, 뷰티, 푸드, 에이전시, 금융 등
- **분위기**: 사용자가 언급했다면 반영, 아니라면 Step 2에서 선택받기

---

## Step 2: 디자인 스타일 선택 제안

**사용자가 이미 스타일/분위기를 명시한 경우 이 단계를 건너뛰고 Step 3으로 진행하세요.**
(예: "어두운", "미니멀", "친환경", "파스텔", "어스톤" 등 명확한 방향이 있을 때)

스타일이 불명확한 경우에만 아래 형식으로 선택지를 제시하세요. **반드시 클로드 추천을 포함**하고, 추천 이유를 한 줄로 설명할 것.

```
🎨 어떤 스타일로 만들까요?

A. 어스톤 미니멀
   따뜻한 모카·테라코타·크림 팔레트, 깔끔한 여백 중심 레이아웃
   → 라이프스타일, 브랜드, 웰니스, 푸드 사이트에 어울려요

B. 다크 테크
   딥 네이비 배경 + 네온 포인트 컬러, 날카롭고 현대적인 인상
   → SaaS, 테크 스타트업, 게임, 크리에이티브 에이전시에 어울려요

C. 소프트 파스텔
   라벤더·피치·버터크림 계열, 부드럽고 친근한 느낌
   → 뷰티, 웰니스, 교육, 아동 서비스에 어울려요

D. 볼드 브루탈리즘
   강렬한 흑백 + 원색 포인트, 장식 없는 날것의 임팩트
   → 포트폴리오, 에이전시, 아트 프로젝트에 어울려요

E. 레트로 리바이벌
   빈티지 팔레트 + 현대적 레이아웃, 개성 있는 브랜드 경험
   → 패션, 푸드, 문화·예술 브랜드에 어울려요

⭐ 클로드 추천: [선택지 + 이유 1줄]
```

컨텍스트가 충분히 명확하다면 추천에 가중치를 두되, 항상 사용자가 최종 선택을 합니다.

---

## Step 3: 레이아웃 패턴 결정

`references/layout.md`를 참고해 타입에 맞는 패턴을 선택하세요:

| 타입                | 권장 패턴                                     |
| ------------------- | --------------------------------------------- |
| 랜딩페이지          | Above-the-fold CTA + Storytelling 스크롤 구조 |
| 대시보드/앱         | 벤토 박스 레이아웃                            |
| 포트폴리오/에이전시 | 탈구축 히어로 + Bold Kinetic Typography       |
| e-커머스            | 그리드 중심 + 마이크로인터랙션 강조           |
| 단일 컴포넌트       | 해당 컴포넌트의 용도에 맞는 스타일            |

---

## Step 4: 구현

### 컬러 설정

`references/color.md`에서 선택된 스타일의 정확한 HEX값을 사용해 `tailwind.config.ts`에 커스텀 컬러를 정의하세요.

```ts
// tailwind.config.ts 예시 (어스톤 스타일)
colors: {
  mocha: {
    DEFAULT: '#9E7B5A',
    light: '#C4A882',
    dark: '#7D5F42',
    deep: '#5C3D2E',
  },
  cream: '#FAF7F2',
  sage: '#8FAF7E',
  terracotta: '#C4724A',
}
```

### 컴포넌트 코드 원칙

- **shadcn/ui를 베이스**로 사용하고 Tailwind로 커스터마이징
- **Next.js App Router** 기준 작성 (서버 컴포넌트 우선, 클라이언트 인터랙션 필요 시 `'use client'`)
- **`next/image`** 사용, **`next/font`**로 폰트 최적화
- 이미지 포맷은 WebP/AVIF 우선 권장

### 인터랙션 추가

`references/interaction.md`를 참고해 요청 복잡도에 따라 적용하세요:

**기본 (항상 포함)**

```tsx
// 버튼 hover/active 피드백
className =
  "transition-all duration-200 hover:-translate-y-0.5 hover:shadow-md active:scale-95";

// 폼 에러 흔들림
className = "animate-shake border-red-500";
```

**중간 (일반 페이지/컴포넌트)**

- 스켈레톤 UI (로딩 상태)
- 스크롤 reveal (Intersection Observer)
- 좋아요/체크 완료 애니메이션

**고급 (랜딩페이지, 포트폴리오 등)**

- 패럴랙스 스크롤
- 다이나믹 커서 (포트폴리오·에이전시에서만)
- Bold Kinetic Typography 스크롤 연동

### 접근성 — 타협 불가

```tsx
// 색상 대비 4.5:1 이상 유지
// aria 태그 적용
<Button aria-label="장바구니에 추가">

// 터치 타깃 최소 44×44px
className="min-h-[44px] min-w-[44px]"

// 포커스 인디케이터
className="focus-visible:ring-2 focus-visible:ring-offset-2"

// 애니메이션 접근성
<motion.div className="motion-reduce:animate-none">
```

---

## Step 5: 출력물 구성

**항상 다음 순서로 출력하세요:**

### 1. `design-summary.md` 파일 생성

선택된 스타일, 레이아웃 패턴, 주요 컬러, 인터랙션 방향과 그 이유를 **파일로 저장**하세요. (5-7줄 이상)

```md
# Design Summary

## 스타일
[선택된 스타일과 선택 이유]

## 레이아웃
[사용한 레이아웃 패턴과 이유]

## 컬러 팔레트
[주요 컬러와 선택 이유]

## 인터랙션
[적용한 인터랙션과 이유]
```

### 2. `tailwind.config.ts`

커스텀 컬러, 폰트, 필요한 플러그인 설정.

### 3. 컴포넌트/페이지 코드

완성된 Next.js + Tailwind + shadcn/ui 코드. 실제로 복사해서 쓸 수 있는 수준으로.

### 4. 추가 설치 패키지 (있을 경우)

```bash
npm install [패키지명]
npx shadcn@latest add [컴포넌트]
```

---

## 트렌드 핵심 원칙

**레이아웃**

- Mobile-First: 모바일 뷰를 먼저 설계, 데스크탑은 확장
- Above-the-fold: 핵심 정보와 CTA는 스크롤 없이 보여야 함
- 정보 위계: 벤토 박스의 크기 차이처럼 레이아웃 자체가 중요도를 표현

**타이포그래피**

- 히어로: 뷰포트를 꽉 채우는 대형 Bold 헤드라인 (`text-[clamp(3rem,10vw,8rem)]`)
- 혼합 폰트: 디스플레이 폰트(헤드라인) + 읽기 쉬운 폰트(본문)
- 폰트 선택 시 `references/fonts.md`의 업종별 조합 테이블과 치트시트를 참고하세요

**퍼포먼스**

- `next/image`로 이미지 자동 최적화
- 시스템 폰트 우선, 커스텀 폰트는 WOFF2 + `font-display: swap`
- `prefers-reduced-motion`으로 애니메이션 접근성 고려

---

## 레퍼런스 파일

필요할 때 해당 파일을 읽어 정확한 값을 사용하세요:

- **컬러 팔레트 HEX값**: `references/color.md`
- **인터랙션 패턴 상세**: `references/interaction.md`
- **레이아웃 스타일 상세**: `references/layout.md`
- **트렌드 종합 보고서**: `references/trend.md`
- **폰트 추천 / 업종별 조합 / 치트시트**: `references/fonts.md`
