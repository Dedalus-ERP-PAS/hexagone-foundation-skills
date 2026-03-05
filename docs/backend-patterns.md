# Backend Development Patterns

Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes.

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

### Caching Strategies
- Redis Caching Layer (cache-aside pattern)
- Invalidation de cache
- TTL management

### Error Handling
- Centralized Error Handler (ApiError class)
- Retry with Exponential Backoff
- Error logging structuré

### Authentication & Authorization
- JWT Token Validation
- Role-Based Access Control (RBAC)
- Permission middleware

### Rate Limiting
- In-Memory Rate Limiter
- IP-based limiting
- Window-based tracking

### Background Jobs & Queues
- Simple Queue Pattern
- Job processing avec retry
- Asynchronous task handling

### Logging & Monitoring
- Structured Logging (JSON logs)
- Request tracking
- Error context

## Principes clés

1. **Separation of Concerns** - Séparer les couches (API, logique métier, accès données)
2. **Start Simple** - Commencer simple, ajouter de la complexité quand nécessaire
3. **Type Safety** - Utiliser TypeScript et validation de schémas
4. **Error First** - Gérer les erreurs de manière proactive
5. **Cache Wisely** - Cacher les données fréquemment accédées et rarement modifiées
6. **Secure by Default** - Toujours valider, authentifier et autoriser

## Exemples d'utilisation

### Créer une API avec Repository Pattern

```typescript
// 1. Définir l'interface du repository
interface UserRepository {
  findById(id: string): Promise<User | null>
  create(data: CreateUserDto): Promise<User>
}

// 2. Implémenter avec votre DB
class SupabaseUserRepository implements UserRepository {
  async findById(id: string): Promise<User | null> {
    const { data } = await supabase
      .from('users')
      .select('*')
      .eq('id', id)
      .single()
    return data
  }
}

// 3. Utiliser dans le service
class UserService {
  constructor(private repo: UserRepository) {}
  
  async getUser(id: string) {
    return this.repo.findById(id)
  }
}
```

### Ajouter du caching Redis

```typescript
class CachedUserRepository implements UserRepository {
  constructor(
    private baseRepo: UserRepository,
    private redis: RedisClient
  ) {}

  async findById(id: string): Promise<User | null> {
    // Check cache
    const cached = await this.redis.get(`user:${id}`)
    if (cached) return JSON.parse(cached)

    // Cache miss - fetch from DB
    const user = await this.baseRepo.findById(id)
    
    if (user) {
      // Cache for 5 minutes
      await this.redis.setex(`user:${id}`, 300, JSON.stringify(user))
    }

    return user
  }
}
```

### Implémenter l'authentification JWT

```typescript
export async function requireAuth(request: Request) {
  const token = request.headers
    .get('authorization')
    ?.replace('Bearer ', '')

  if (!token) {
    throw new ApiError(401, 'Missing token')
  }

  return verifyToken(token)
}

// Usage dans une API route
export async function GET(request: Request) {
  const user = await requireAuth(request)
  const data = await getUserData(user.id)
  return NextResponse.json({ success: true, data })
}
```

## Technologies supportées

- Node.js
- Express
- Next.js API Routes
- TypeScript
- Supabase / PostgreSQL
- Redis
- JWT

## Bonnes pratiques

- Toujours valider les inputs avec Zod ou équivalent
- Utiliser des transactions pour les opérations liées
- Éviter les N+1 queries avec batch fetching
- Implémenter du retry avec exponential backoff
- Logger avec contexte structuré (JSON)
- Sécuriser les endpoints avec auth middleware
- Rate limit les APIs publiques
- Cacher les données fréquemment accédées

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/backend-patterns)
- [Source originale](https://github.com/affaan-m/everything-claude-code/blob/main/skills/backend-patterns.md)

## Licence

MIT
