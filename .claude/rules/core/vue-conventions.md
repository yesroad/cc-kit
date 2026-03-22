# Vue 컨벤션

> Vue 3 + Composition API 프로젝트 전용 규칙
> React/Next.js 프로젝트에서는 적용하지 않는다

---

## 적용 조건 확인

```bash
# package.json에서 Vue 버전 확인
cat package.json | grep vue
```

---

## Composition API 필수

Options API 대신 Composition API (`<script setup>`)를 사용한다.

```vue
<!-- ❌ 금지: Options API -->
<script>
export default {
  data() { return { count: 0 } },
  methods: { increment() { this.count++ } }
}
</script>

<!-- ✅ 필수: Composition API + script setup -->
<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
const increment = () => { count.value++ }
</script>
```

---

## 컴포넌트 네이밍

| 유형 | 규칙 | 예시 |
|------|------|------|
| 파일명 | PascalCase | `OrderCard.vue` |
| 템플릿 사용 | PascalCase | `<OrderCard />` |
| props | camelCase | `orderStatus` |
| emit | kebab-case | `@update-status` |

---

## 상태 관리 (Pinia)

전역 상태는 Pinia store로 관리한다.

```typescript
// stores/order.ts
import { defineStore } from 'pinia'

export const useOrderStore = defineStore('order', () => {
  const orders = ref<Order[]>([])
  const isLoading = ref(false)

  const fetchOrders = async () => {
    isLoading.value = true
    orders.value = await orderService.getList()
    isLoading.value = false
  }

  return { orders, isLoading, fetchOrders }
})
```

---

## Props 타입 정의

```vue
<script setup lang="ts">
interface Props {
  order: Order
  isSelected?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  isSelected: false,
})
</script>
```

---

## Emit 타입 정의

```vue
<script setup lang="ts">
interface Emits {
  (e: 'update-status', status: string): void
  (e: 'delete', id: string): void
}

const emit = defineEmits<Emits>()
</script>
```

---

## Composable 패턴

재사용 로직은 `composables/` 디렉토리에 `use` 접두사로 작성한다.

```typescript
// composables/useOrderFilter.ts
export function useOrderFilter(orders: Ref<Order[]>) {
  const filterStatus = ref('all')

  const filteredOrders = computed(() =>
    filterStatus.value === 'all'
      ? orders.value
      : orders.value.filter(o => o.status === filterStatus.value)
  )

  return { filterStatus, filteredOrders }
}
```

---

## 금지 패턴

| 금지 | 대안 |
|------|------|
| Options API | Composition API (`<script setup>`) |
| Vuex | Pinia |
| `this.$emit` | `defineEmits` |
| `this.$refs` | `useTemplateRef()` 또는 `ref()` |
| Mixin | Composable |

---

## 참조 문서

| 문서 | 용도 |
|------|------|
| `coding-standards.md` | 기본 TypeScript 표준 |
| `unit-test-conventions.md` | 테스트 작성 규칙 |
| `accessibility.md` | 접근성 규칙 |
