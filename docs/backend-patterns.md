# backend-patterns

Patterns d'architecture backend et bonnes pratiques server-side pour Node.js, Express et Next.js API Routes.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Concevoir des APIs RESTful robustes
- Implémenter des patterns d'architecture backend (Repository, Service Layer, Middleware)
- Optimiser les requêtes de base de données
- Mettre en place du caching avec Redis
- Gérer les erreurs de manière centralisée
- Implémenter l'authentification et l'autorisation (JWT, RBAC)
- Ajouter du rate limiting
- Gérer les jobs en arrière-plan
- Implémenter du logging structuré

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill backend-patterns -g -y
```

## Contenu du skill

### API Design Patterns
- Structure RESTful API (URLs resource-based, query parameters)
- Repository Pattern (abstraction de l'accès aux données)
- Service Layer Pattern (logique métier séparée)
- Middleware Pattern (pipeline de traitement)

### Database Patterns
- Query Optimization (sélection de colonnes, indexation)
- N+1 Query Prevention (batch fetching)
- Transaction Pattern (opérations atomiques)

### Caching
- Redis Caching Layer (cache-aside pattern)
- Invalidation de cache
- TTL management

### Gestion d'erreurs
- Centralized Error Handler (classe ApiError)
- Retry with Exponential Backoff
- Logging structuré des erreurs

### Authentification & Autorisation
- JWT Token Validation
- Role-Based Access Control (RBAC)
- Permission middleware

### Rate Limiting, Jobs, Logging
- Rate limiter en mémoire (IP-based, window-based)
- Queue pattern avec retry
- Structured logging (JSON)

## Principes clés

1. **Separation of Concerns** — Séparer les couches (API, logique métier, accès données)
2. **Start Simple** — Commencer simple, complexifier au besoin
3. **Type Safety** — Utiliser TypeScript et validation de schémas
4. **Error First** — Gérer les erreurs de manière proactive
5. **Cache Wisely** — Cacher les données fréquemment lues, rarement modifiées
6. **Secure by Default** — Toujours valider, authentifier et autoriser

## Exemples d'utilisation

### Créer une API avec Repository Pattern

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>
  create(data: CreateUserDto): Promise<User>
}

class SupabaseUserRepository implements UserRepository {
  async findById(id: string) {
    const { data } = await supabase
      .from('users').select('*').eq('id', id).single()
    return data
  }
}
```

### Ajouter du caching Redis

```typescript
class CachedUserRepository implements UserRepository {
  constructor(private repo: UserRepository, private redis: RedisClient) {}

  async findById(id: string): Promise<User | null> {
    const cached = await this.redis.get(`user:${id}`)
    if (cached) return JSON.parse(cached)
    const user = await this.repo.findById(id)
    if (user) await this.redis.setex(`user:${id}`, 300, JSON.stringify(user))
    return user
  }
}
```

## Technologies supportées

Node.js, Express, Next.js API Routes, TypeScript, Supabase / PostgreSQL, Redis, JWT

## Bonnes pratiques

- Toujours valider les inputs avec Zod ou équivalent
- Utiliser des transactions pour les opérations liées
- Éviter les N+1 queries avec batch fetching
- Implémenter du retry avec exponential backoff
- Logger avec contexte structuré (JSON)
- Sécuriser les endpoints avec auth middleware
- Rate limit les APIs publiques

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/backend-patterns)
- [SKILL.md complet](../skills/backend-patterns/SKILL.md) — Tous les patterns avec exemples détaillés
