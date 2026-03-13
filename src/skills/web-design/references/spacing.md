# 여백·간격·개행·반응형 가이드

---

## 1. 컴포넌트 내부 Padding 기준

### 버튼
```tsx
// 텍스트 길이에 비례한 padding 사용
// 한 단어 버튼 (구독하기, 시작하기 등)
className="px-6 py-2.5"       // 기본 크기
className="px-8 py-3"         // 중간 크기
className="px-10 py-4"        // 대형 CTA

// ❌ 한 단어 버튼에 px-12 이상은 과도함 → 여백이 텍스트보다 커 보임
// ✅ 시각적으로 텍스트가 버튼 중앙에 자연스럽게 위치하면 OK
```

### 카드
```tsx
className="p-4"    // 작은 카드 (대시보드 위젯, 뱃지형)
className="p-5"    // 일반 카드
className="p-6"    // 넓은 카드 (랜딩페이지, 피처 섹션)
className="p-8"    // 히어로급 카드

// 내부 요소 간 gap
className="flex flex-col gap-3"  // 콤팩트
className="flex flex-col gap-4"  // 일반
className="flex flex-col gap-6"  // 여유 있는 레이아웃
```

### 섹션
```tsx
// 섹션 간 수직 간격
className="py-16"   // 컴팩트 (앱 화면, 대시보드)
className="py-20"   // 일반 페이지
className="py-24"   // 랜딩페이지 섹션
className="py-32"   // 히어로 영역

// 같은 섹션 내 요소 간
className="space-y-4"   // 관련 요소 (레이블+인풋)
className="space-y-6"   // 섹션 내 블록
className="space-y-12"  // 서브섹션 구분
```

---

## 2. 요소 간 간격 규칙

### 나란히 배치된 요소들
```tsx
// 같은 역할의 버튼/아이콘 묶음 → gap 동일하게
<div className="flex items-center gap-2">
  <Button size="icon">♡</Button>
  <Button size="icon">⊕</Button>
</div>

// 가격+버튼처럼 정보 밀도 높은 영역
// → 넘치거나 잘리지 않도록 flex-shrink, min-w 명시
<div className="flex items-center gap-3 min-w-0">
  <span className="font-bold whitespace-nowrap">₩25,600</span>
  <span className="line-through text-muted flex-shrink-0">₩32,000</span>
  <div className="flex gap-2 flex-shrink-0">
    <Button size="icon">♡</Button>
    <Button>+ 담기</Button>
  </div>
</div>
```

### 과도한 여백 방지
```tsx
// ❌ 버튼/배지 하나만 있는데 py-16 이상
<section className="py-20">
  <Button>구독하기</Button>  {/* 내용 없이 공간만 크면 허전 */}
</section>

// ✅ 보조 텍스트나 설명 추가, 또는 padding 줄이기
<section className="py-12">
  <p className="text-muted-foreground mb-4">매주 화요일, 새로운 이야기를 전합니다</p>
  <Button>구독하기</Button>
</section>
```

---

## 3. 한국어 텍스트 개행 처리

한국어는 조사·어미가 짧아 줄 끝에 한두 글자만 남는 어색한 개행이 자주 발생합니다.

```tsx
// ❌ 어색한 개행 — "니다." 혼자 두 번째 줄
// "신제품 출시, 친환경 팁, 회원 전용 할인까지. 매주 화요일,
//  자연이 담긴 이야기를 전합
//  니다."

// ✅ 방법 1: break-keep (단어 단위 개행, 음절 중간 끊김 방지)
className="break-keep"

// ✅ 방법 2: max-width 조정으로 자연스러운 줄바꿈 유도
className="max-w-[280px] break-keep"

// ✅ 방법 3: 의미 단위로 <br /> 직접 삽입 (고정 레이아웃)
<p>신제품 출시, 친환경 팁, 회원 전용 할인까지.<br />
매주 화요일, 자연이 담긴 이야기를 전합니다.</p>
```

**적용 기준**

| 위치 | 처리 방법 |
|------|----------|
| 히어로 헤드라인 | `break-keep` 필수 |
| `text-center` 단락 | `break-keep` + `max-w` 조합 |
| 본문/설명 텍스트 | `break-keep` 기본 적용 |
| 버튼 레이블 | `whitespace-nowrap` |
| 긴 고정 카피 | `<br />` 직접 삽입 |

---

## 4. 반응형 브레이크포인트 활용 기준

Tailwind 기본 브레이크포인트: `sm(640px)` · `md(768px)` · `lg(1024px)` · `xl(1280px)` · `2xl(1536px)`

### 카드 그리드
```tsx
// 기본: 1열 → 태블릿: 2열 → 데스크탑: 3~4열
className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4"

// 벤토 박스 (크기 혼합)
className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3"
```

### 히어로 섹션
```tsx
// 모바일: 세로 스택 → 데스크탑: 2컬럼
<section className="flex flex-col lg:flex-row items-center gap-8 py-20">
  <div className="flex-1 text-center lg:text-left">
    <h1 className="text-[clamp(2rem,6vw,5rem)] font-black break-keep">...</h1>
  </div>
  <div className="flex-1">이미지/비주얼</div>
</section>
```

### 네비게이션
```tsx
// 모바일: 햄버거 메뉴 / 데스크탑: 풀 메뉴
<nav>
  <div className="hidden md:flex items-center gap-6">...</div>  {/* 데스크탑 메뉴 */}
  <Button className="md:hidden" variant="ghost">☰</Button>     {/* 모바일 햄버거 */}
</nav>
```

### 타이포그래피 스케일
```tsx
// clamp로 유체(fluid) 타이포그래피
className="text-[clamp(2rem,5vw,4rem)]"   // 섹션 헤드라인
className="text-[clamp(3rem,8vw,7rem)]"   // 히어로 대형 헤드라인
className="text-[clamp(1rem,2vw,1.25rem)]"  // 본문 유동 크기

// 단계별 고정 스케일 (심플한 방식)
className="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-black"
```

### 간격 반응형 조정
```tsx
// 모바일에선 좁게, 데스크탑에선 넓게
className="px-4 sm:px-6 lg:px-8"           // 컨테이너 측면 padding
className="py-12 md:py-16 lg:py-24"        // 섹션 수직 padding
className="gap-3 md:gap-4 lg:gap-6"        // 그리드/플렉스 gap
```

---

## 5. 품질 체크리스트

구현 완료 후 출력 전 확인:

- [ ] 버튼 padding이 텍스트 대비 과도하거나 부족하지 않은가?
- [ ] 나란히 배치된 요소들의 `gap`이 일관적인가?
- [ ] 가격·버튼 등 정보 밀도 높은 영역에서 요소가 잘리거나 넘치지 않는가?
- [ ] 한국어 텍스트에 `break-keep` 또는 `max-w`가 적용되었는가?
- [ ] `text-center` 단락에서 마지막 줄에 단어 한두 개만 남지 않는가?
- [ ] 버튼 레이블에 `whitespace-nowrap`이 적용되었는가?
- [ ] 특정 영역만 공백이 과도하게 크지 않은가?
- [ ] 모바일(375px) 기준에서 레이아웃이 깨지지 않는가?
- [ ] 히어로 헤드라인에 `clamp()` 또는 반응형 텍스트 크기가 적용되었는가?
