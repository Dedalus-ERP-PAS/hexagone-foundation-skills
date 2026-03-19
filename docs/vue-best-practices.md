# vue-best-practices

Bonnes pratiques Vue.js 3 et Nuxt : Composition API, patterns de composants et organisation de code.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Structurer des composants Vue.js avec `<script setup>`
- Créer des composables réutilisables
- Typer correctement les props, events et refs avec TypeScript
- Éviter les anti-patterns courants (mutation de props, v-if avec v-for)

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill vue-best-practices -g -y
```

## Composition API

### Structure `<script setup>`

```vue
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

const props = defineProps<{ userId: string }>()
const emit = defineEmits<{ submit: [data: FormData] }>()
const { user, loading } = useUser(props.userId)

const formData = ref({ name: '', email: '' })
const isValid = computed(() => formData.value.name.length > 0)

function handleSubmit() {
  if (isValid.value) emit('submit', formData.value)
}
</script>
```

**Ordre recommandé** : imports, props/emits, composables, etat reactif, computed, methodes, lifecycle hooks.

### ref vs reactive

```javascript
// ref() pour primitives et valeurs réassignées
const count = ref(0)
const user = ref<User | null>(null)

// reactive() pour objets mutés
const state = reactive({ items: [], loading: false })

// Utiliser toRefs pour destructurer reactive
const { count } = toRefs(state)
```

### Composables

```typescript
// composables/useUser.ts
export function useUser(userId: Ref<string> | string) {
  const user = ref<User | null>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  async function fetchUser(id: string) {
    loading.value = true
    try { user.value = await api.getUser(id) }
    catch (e) { error.value = e as Error }
    finally { loading.value = false }
  }

  return { user: readonly(user), loading, error }
}
```

## Props et Events

### Props typées avec defaults

```vue
<script setup lang="ts">
interface Props {
  title: string
  size?: 'sm' | 'md' | 'lg'
  items?: string[]
}
const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  items: () => []
})
</script>
```

### v-model avec defineModel (Vue 3.4+)

```vue
<script setup lang="ts">
const model = defineModel<string>({ required: true })
</script>

<template>
  <input v-model="model" />
</template>
```

## Anti-patterns

| Anti-pattern | Correction |
|-------------|-----------|
| **Muter les props** | Emettre un event (`emit('update:items', [...props.items, newItem])`) |
| **v-if avec v-for** | Utiliser un `computed` pour filtrer en amont |
| **Etat dérivé stocké** | Remplacer `watch` + `ref` par un `computed` |
| **Destructurer reactive** | Utiliser `toRefs()` pour garder la réactivité |

## TypeScript

### Template refs typées

```vue
<script setup lang="ts">
const inputRef = ref<HTMLInputElement | null>(null)
</script>
<template>
  <input ref="inputRef" />
</template>
```

### Provide/Inject typés

```typescript
// types/keys.ts
export const UserKey: InjectionKey<Ref<User>> = Symbol('user')

// Parent: provide(UserKey, user)
// Child:  const user = inject(UserKey)
```

## Bonnes pratiques générales

- **Single Responsibility** : Un composant = une responsabilité
- **Props Down, Events Up** : Flux de données unidirectionnel
- **Composables pour la réutilisation** : Extraire la logique partagée
- **Computed pour les valeurs dérivées** : Jamais de watch pour synchroniser
- **`<script setup>`** : Toujours utiliser pour les SFC (Single File Components)
- **Taille des composants** : Limiter a ~200 lignes

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/vue-best-practices)
- [SKILL.md complet](../skills/vue-best-practices/SKILL.md) — Tous les patterns avec exemples détaillés
