---
name: typescript-migration
description: Guide for incrementally migrating JavaScript codebases to TypeScript. Covers tsconfig setup, file-by-file migration, typing strategies for legacy code, handling `any`, and common pitfalls. Use when the user wants to convert JS to TS, add types to existing code, set up TypeScript in a JS project, or improve type safety.
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
---

# TypeScript Migration Guide

Incremental strategy for migrating JavaScript codebases to TypeScript. Designed for legacy projects that need progressive, non-disruptive migration.

## When to Use This Skill

Activate when the user:
- Wants to convert a JS project (or parts of it) to TypeScript
- Needs to add TypeScript to an existing JavaScript project
- Asks about typing legacy code or reducing `any` usage
- Wants to improve type safety incrementally
- Is setting up tsconfig for a mixed JS/TS codebase

## Core Principle: Incremental Migration

**Never rewrite everything at once.** Migrate file by file, starting from the leaves of the dependency tree. Every intermediate state must be a working codebase.

```
Phase 1: Setup          → tsconfig + tooling, zero code changes
Phase 2: Rename         → .js → .ts for leaf files, fix type errors
Phase 3: Type boundaries → Add types to public APIs and shared interfaces
Phase 4: Deepen         → Enable stricter checks, eliminate `any`
Phase 5: Strict mode    → Full strict TypeScript
```

## Phase 1: Project Setup

### 1.1 Install TypeScript

```bash
npm install --save-dev typescript @types/node
```

For framework-specific types:

```bash
# React
npm install --save-dev @types/react @types/react-dom

# Express
npm install --save-dev @types/express

# Vue (types included in vue package)
# No extra install needed
```

### 1.2 Create tsconfig.json

Start permissive, tighten later:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,

    "allowJs": true,
    "checkJs": false,

    "strict": false,
    "noImplicitAny": false,
    "strictNullChecks": false,

    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.*"]
}
```

**Key settings for migration:**
- `allowJs: true` — allows mixed JS/TS
- `checkJs: false` — don't type-check JS files yet
- `strict: false` — start permissive
- `noImplicitAny: false` — allow implicit `any` initially

### 1.3 Update Build Tools

Most modern tools support TS out of the box:

```bash
# Vite — zero config needed
# Next.js — zero config, just rename files
# Webpack — add ts-loader or use babel
npm install --save-dev ts-loader
```

## Phase 2: Rename and Fix (Leaf-First)

### 2.1 Identify Migration Order

Start from files with NO internal imports (leaf nodes), then work up:

```
Level 0 (first):  utils/formatDate.js     → no imports from src/
Level 0 (first):  constants/index.js       → no imports from src/
Level 1:          services/dateService.js   → imports from utils/
Level 2:          api/patientApi.js         → imports from services/
Level 3 (last):   pages/PatientList.jsx     → imports from everything
```

### 2.2 Rename One File at a Time

```bash
# Rename
mv src/utils/formatDate.js src/utils/formatDate.ts

# Fix type errors
# Run build/IDE to see errors
npx tsc --noEmit
```

### 2.3 Typing Strategy Per File

For each renamed file:

1. **Add explicit return types** to exported functions
2. **Add parameter types** to exported functions
3. **Add interface/type for complex objects**
4. **Use `unknown` instead of `any`** where possible
5. **Keep internal functions loosely typed** initially — tighten later

```typescript
// BEFORE (JavaScript)
export function formatPatientName(patient) {
  return `${patient.lastName} ${patient.firstName}`
}

// AFTER (TypeScript — Phase 2)
interface Patient {
  lastName: string
  firstName: string
}

export function formatPatientName(patient: Patient): string {
  return `${patient.lastName} ${patient.firstName}`
}
```

## Phase 3: Type Boundaries

Focus on typing the **public API surface** — exports, function signatures, shared types.

### 3.1 Create Shared Type Files

```typescript
// src/types/patient.ts
export interface Patient {
  id: string
  lastName: string
  firstName: string
  birthDate: string  // ISO 8601
  sex: 'M' | 'F' | 'U'
  ipp?: string       // Internal Patient ID (optional)
}

export interface PatientSearchParams {
  query?: string
  unit?: string
  page?: number
  limit?: number
}

export type PatientCreateInput = Omit<Patient, 'id'>
```

### 3.2 Type API Responses

```typescript
// src/types/api.ts
export interface ApiResponse<T> {
  success: boolean
  data: T
  error?: ApiError
}

export interface ApiError {
  code: string
  message: string
  details?: Record<string, string[]>
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number
    limit: number
    total: number
    totalPages: number
  }
}
```

### 3.3 Type Event/Message Payloads

Especially important for healthcare message processing:

```typescript
// src/types/hpk.ts
export type HPKMessageType = 'ID' | 'MV' | 'CV' | 'PR' | 'FO'
export type HPKMode = 'C' | 'M' | 'D'

export interface HPKMessage {
  type: HPKMessageType
  code: string
  mode: HPKMode
  sender: string
  timestamp: string
  userId: string
  fields: string[]
}

// Discriminated union for type-safe message handling
export type HPKIdentityMessage = HPKMessage & {
  type: 'ID'
  patient: {
    id: string
    lastName: string
    firstName: string
    birthDate: string
    sex: 'M' | 'F'
  }
}

export type HPKMovementMessage = HPKMessage & {
  type: 'MV'
  visit: {
    id: string
    unit: string
    bed?: string
  }
}

export type TypedHPKMessage = HPKIdentityMessage | HPKMovementMessage
```

## Phase 4: Tighten the Compiler

Enable stricter checks one at a time. After each change, fix all errors before enabling the next.

### Recommended Order

```json
// Step 1 — catch null/undefined bugs (highest value)
"strictNullChecks": true

// Step 2 — catch missing types
"noImplicitAny": true

// Step 3 — catch forgotten returns
"noImplicitReturns": true

// Step 4 — catch switch fallthrough
"noFallthroughCasesInSwitch": true

// Step 5 — full strict mode (enables all strict options)
"strict": true
```

### Dealing with `strictNullChecks` Errors

Most common patterns:

```typescript
// Problem: Object is possibly 'undefined'
const patient = patients.find(p => p.id === id)
patient.name  // Error!

// Fix 1: Guard clause (preferred)
if (!patient) {
  throw new Error(`Patient ${id} not found`)
}
patient.name  // OK — TypeScript narrows the type

// Fix 2: Optional chaining (when absence is expected)
const name = patient?.name ?? 'Unknown'

// Fix 3: Non-null assertion (LAST RESORT — avoid if possible)
patient!.name  // Suppresses error, but defeats the purpose
```

### Eliminating `any`

```typescript
// STEP 1: Replace `any` with `unknown`
function parseMessage(raw: unknown): HPKMessage {
  if (typeof raw !== 'string') {
    throw new Error('Expected string input')
  }
  // Now TypeScript knows raw is a string
  const parts = raw.split('|')
  // ...
}

// STEP 2: Use type guards for runtime checking
function isPatient(data: unknown): data is Patient {
  return (
    typeof data === 'object' &&
    data !== null &&
    'id' in data &&
    'lastName' in data
  )
}

// STEP 3: Use Zod for validated parsing (recommended)
import { z } from 'zod'

const PatientSchema = z.object({
  id: z.string(),
  lastName: z.string(),
  firstName: z.string(),
  birthDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  sex: z.enum(['M', 'F', 'U']),
})

type Patient = z.infer<typeof PatientSchema>

function parsePatient(data: unknown): Patient {
  return PatientSchema.parse(data)  // Throws ZodError if invalid
}
```

## Phase 5: Strict Mode

When all files are `.ts` and all strict checks pass individually:

```json
{
  "compilerOptions": {
    "strict": true,
    "allowJs": false,
    "checkJs": false
  }
}
```

Remove `allowJs` since all files are now TypeScript.

## Common Patterns for Legacy Code

### Typing Callback-Heavy Code

```typescript
// Legacy pattern with callbacks
function fetchData(url: string, callback: (err: Error | null, data?: unknown) => void): void

// Modern replacement
async function fetchData(url: string): Promise<unknown>
```

### Typing Dynamic Objects

```typescript
// When the shape varies at runtime (e.g., config, feature flags)
type Config = Record<string, string | number | boolean>

// When you know some keys but not all
interface AppConfig {
  apiUrl: string
  debug: boolean
  [key: string]: unknown  // Allow additional unknown keys
}
```

### Typing Third-Party Libraries Without Types

```typescript
// Create src/types/untyped-lib.d.ts
declare module 'legacy-hpk-decoder' {
  export function decode(message: string): Record<string, string>
  export function encode(fields: Record<string, string>): string
}
```

### Typing Express Middleware

```typescript
import { Request, Response, NextFunction } from 'express'

interface AuthenticatedRequest extends Request {
  user: {
    id: string
    roles: string[]
  }
}

function requireAuth(req: Request, res: Response, next: NextFunction): void {
  const token = req.headers.authorization?.replace('Bearer ', '')
  if (!token) {
    res.status(401).json({ error: 'Unauthorized' })
    return
  }
  // Attach user to request
  ;(req as AuthenticatedRequest).user = verifyToken(token)
  next()
}
```

## Migration Checklist

### Before Starting
```
[ ] Team aligned on migration (not a solo effort)
[ ] Build pipeline supports .ts files
[ ] IDE configured for TypeScript (tsserver)
[ ] tsconfig.json created with permissive settings
[ ] @types packages installed for dependencies
```

### Per File
```
[ ] File renamed .js → .ts (or .jsx → .tsx)
[ ] Exported functions have explicit parameter and return types
[ ] Complex objects have interfaces/types defined
[ ] No new `any` introduced (use `unknown` + type guards)
[ ] Tests still pass after conversion
[ ] No `// @ts-ignore` or `// @ts-expect-error` (unless temporary, with TODO)
```

### Before Enabling Strict
```
[ ] All files are .ts/.tsx
[ ] strictNullChecks enabled and all errors fixed
[ ] noImplicitAny enabled and all errors fixed
[ ] No remaining `any` in public APIs
[ ] Shared types defined in types/ directory
[ ] Type coverage > 90%
```

## Common Pitfalls

| Pitfall | Why It's Bad | Fix |
|---------|-------------|-----|
| `as any` everywhere | Defeats the purpose of TypeScript | Use `unknown` + type guards |
| Rewriting code during migration | Introduces bugs, blocks progress | Migrate types only, refactor later |
| Starting with strict mode | Too many errors, team gives up | Start permissive, tighten gradually |
| Migrating test files first | Tests don't need strict types | Migrate source first, tests last |
| Giant PR with 50 files | Unreviewable, merge conflicts | One file or module per PR |
| Ignoring `@types` packages | Missing types for dependencies | Install `@types/*` as you go |
