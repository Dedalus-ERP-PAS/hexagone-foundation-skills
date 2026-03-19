# react-best-practices

Bonnes pratiques React et Next.js : architecture composants, performance, shadcn/ui et patterns modernes (React 19+).

## Quand utiliser ce skill

Utilisez ce skill pour :
- Créer des composants React performants et maintenables
- Optimiser les performances (élimination des waterfalls, bundle size)
- Utiliser shadcn/ui correctement avec des variants CVA
- Ajouter des animations avec Motion (ex-Framer Motion)
- Adopter les patterns React 19+ (Server Components, Server Actions, `useOptimistic`)

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill react-best-practices -g -y
```

## Catégories par priorité

| Priorité | Catégorie | Impact |
|----------|-----------|--------|
| 1 | Architecture composants | CRITIQUE |
| 2 | Élimination des waterfalls | CRITIQUE |
| 3 | Taille du bundle | CRITIQUE |
| 4 | Server Components | ÉLEVÉ |
| 5 | Patterns shadcn/ui | ÉLEVÉ |
| 6 | Gestion d'état | MOYEN-ÉLEVÉ |
| 7 | Animations Motion | MOYEN |
| 8 | Optimisation re-renders | MOYEN |

## Aperçu rapide

### Architecture composants — Composition plutôt qu'héritage

```typescript
function ProductCard({ product }: { product: Product }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{product.name}</CardTitle>
      </CardHeader>
      <CardContent>{product.description}</CardContent>
    </Card>
  )
}
```

### Élimination des waterfalls — Fetching parallèle

```typescript
const [user, posts] = await Promise.all([
  fetchUser(),
  fetchPosts()
])
```

### shadcn/ui — Variants avec CVA

```typescript
import { cva } from 'class-variance-authority'

const buttonVariants = cva('inline-flex items-center', {
  variants: {
    variant: {
      default: 'bg-primary text-primary-foreground',
      destructive: 'bg-destructive text-destructive-foreground',
    }
  }
})
```

### Animations Motion

```typescript
import { motion, AnimatePresence } from 'motion/react'

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.3 }}
>
  {children}
</motion.div>
```

### Server Components et Actions (React 19+)

```typescript
// Server Component (par défaut dans Next.js)
async function ProductPage({ id }: { id: string }) {
  const product = await db.product.findUnique({ where: { id } })
  return <ProductDetails product={product} />
}

// Server Action
'use server'
export async function createPost(formData: FormData) {
  await db.post.create({ data: { title: formData.get('title') } })
  revalidatePath('/posts')
}
```

### Hooks React 19+

```typescript
// useOptimistic — mises à jour UI instantanées
const [optimisticItems, addOptimisticItem] = useOptimistic(
  items,
  (state, newItem) => [...state, newItem]
)

// useActionState — gestion de formulaires
const [state, formAction, isPending] = useActionState(submitFn, null)
```

## Gestion d'état

| Besoin | Solution |
|--------|----------|
| État local | `useState`, `useReducer` |
| État partagé statique | `Context` |
| État URL | `useSearchParams` |
| État serveur | SWR, TanStack Query |
| **Anti-pattern** | État dérivé — calculer plutôt que stocker |

## Accessibilité

- Éléments HTML sémantiques
- Navigation clavier
- Gestion du focus dans les modales
- Respect de `prefers-reduced-motion`

## Librairies clés

| Librairie | Usage |
|-----------|-------|
| [shadcn/ui](https://ui.shadcn.com) | Primitives de composants |
| [Motion](https://motion.dev) | Animations |
| [Radix UI](https://radix-ui.com) | Primitives accessibles |
| [TanStack Query](https://tanstack.com/query) | État serveur |
| [Zod](https://zod.dev) | Validation de schémas |

## Exemples d'utilisation

```
@workspace avec react-best-practices, optimise ce composant Dashboard
@workspace avec react-best-practices, convertis cette page en Server Component
@workspace avec react-best-practices, ajoute des animations Motion à cette liste
```

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/react-best-practices)
- [SKILL.md complet](../skills/react-best-practices/SKILL.md) — Toutes les règles avec exemples détaillés
