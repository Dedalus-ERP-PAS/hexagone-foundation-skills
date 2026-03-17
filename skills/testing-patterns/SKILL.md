---
name: testing-patterns
description: Comprehensive testing patterns and strategies for JavaScript/TypeScript projects. Covers unit, integration, and E2E testing, mocking strategies, test organization, and common anti-patterns. Use when the user wants to write tests, improve test coverage, establish a testing strategy, or fix flaky tests.
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
---

# Testing Patterns & Strategies

Comprehensive guide to testing JavaScript/TypeScript applications. Complements the `tdd` skill (which focuses on workflow) by providing concrete patterns, strategies, and anti-patterns.

## When to Use This Skill

Activate when the user:
- Wants to write tests for existing or new code
- Needs to establish a testing strategy for a project
- Wants to improve test coverage or reliability
- Has flaky or brittle tests
- Asks about mocking, stubbing, or test doubles
- Needs guidance on unit vs integration vs E2E tests

## Testing Pyramid

```
        /  E2E  \          Few, slow, high confidence
       /----------\
      / Integration \      Moderate count, medium speed
     /----------------\
    /      Unit        \   Many, fast, focused
   /____________________\
```

**Rule of thumb:** ~70% unit, ~20% integration, ~10% E2E. Adjust per project — legacy codebases often benefit from more integration tests initially.

## 1. Unit Testing Patterns

### Test Structure: AAA (Arrange, Act, Assert)

```typescript
describe('calculateDiscount', () => {
  it('should apply 10% discount for orders above 100€', () => {
    // Arrange
    const order = { total: 150, items: ['item1', 'item2'] }

    // Act
    const result = calculateDiscount(order)

    // Assert
    expect(result).toBe(135)
  })
})
```

### Naming Convention

Use descriptive names that read as specifications:

```typescript
// GOOD — describes behavior
it('should return 401 when token is expired')
it('should retry 3 times before failing')
it('should trim whitespace from patient name')

// BAD — describes implementation
it('should call validateToken')
it('should set retryCount to 3')
it('should use .trim()')
```

### Parameterized Tests (Table-Driven)

```typescript
describe('parseHL7Date', () => {
  it.each([
    ['20260315', new Date(2026, 2, 15)],
    ['20260315120000', new Date(2026, 2, 15, 12, 0, 0)],
    ['', null],
    ['invalid', null],
  ])('should parse "%s" to %s', (input, expected) => {
    expect(parseHL7Date(input)).toEqual(expected)
  })
})
```

### Testing Error Cases

Always test the unhappy path:

```typescript
describe('PatientService.findById', () => {
  it('should throw NotFoundError for unknown patient ID', async () => {
    await expect(service.findById('UNKNOWN'))
      .rejects.toThrow(NotFoundError)
  })

  it('should throw ValidationError for empty ID', async () => {
    await expect(service.findById(''))
      .rejects.toThrow(ValidationError)
  })
})
```

### Testing Async Code

```typescript
// Promises
it('should resolve with patient data', async () => {
  const patient = await fetchPatient('PAT123')
  expect(patient.name).toBe('DUPONT')
})

// Event emitters
it('should emit "transfer" event on unit change', (done) => {
  emitter.on('transfer', (data) => {
    expect(data.unit).toBe('CARDIO')
    done()
  })
  service.transferPatient('PAT123', 'CARDIO')
})
```

## 2. Integration Testing Patterns

Integration tests verify that components work together correctly.

### Database Integration Tests

```typescript
describe('PatientRepository', () => {
  let db: TestDatabase

  beforeAll(async () => {
    db = await TestDatabase.create()  // Real DB, not mock
    await db.migrate()
  })

  afterEach(async () => {
    await db.truncate()  // Clean between tests
  })

  afterAll(async () => {
    await db.destroy()
  })

  it('should persist and retrieve a patient', async () => {
    const repo = new PatientRepository(db.connection)

    await repo.create({
      id: 'PAT123',
      name: 'DUPONT',
      birthDate: '1975-03-15',
    })

    const found = await repo.findById('PAT123')
    expect(found).toMatchObject({
      id: 'PAT123',
      name: 'DUPONT',
    })
  })
})
```

### API Integration Tests

```typescript
describe('POST /api/patients', () => {
  it('should create a patient and return 201', async () => {
    const response = await request(app)
      .post('/api/patients')
      .send({ name: 'DUPONT', birthDate: '1975-03-15' })
      .set('Authorization', `Bearer ${validToken}`)

    expect(response.status).toBe(201)
    expect(response.body.data.id).toBeDefined()
  })

  it('should return 400 for missing required fields', async () => {
    const response = await request(app)
      .post('/api/patients')
      .send({})  // Missing name
      .set('Authorization', `Bearer ${validToken}`)

    expect(response.status).toBe(400)
    expect(response.body.errors).toContainEqual(
      expect.objectContaining({ field: 'name' })
    )
  })

  it('should return 401 without authentication', async () => {
    const response = await request(app)
      .post('/api/patients')
      .send({ name: 'DUPONT' })

    expect(response.status).toBe(401)
  })
})
```

### Message Processing Integration Tests

Particularly relevant for healthcare message processing (HPK, HL7):

```typescript
describe('HPK Message Pipeline', () => {
  it('should parse, validate, and transform an ID|M1 message', async () => {
    const rawMessage = 'ID|M1|C|HEXAGONE|20260122120000|USER001|PAT123|DUPONT|JEAN|19750315|M'

    const result = await pipeline.process(rawMessage)

    expect(result.type).toBe('ID')
    expect(result.code).toBe('M1')
    expect(result.patient.name).toBe('DUPONT')
    expect(result.valid).toBe(true)
  })
})
```

## 3. E2E Testing Patterns

E2E tests validate complete user workflows through the real application.

### Page Object Pattern

```typescript
class PatientListPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/patients')
  }

  async search(query: string) {
    await this.page.fill('[data-testid="search-input"]', query)
    await this.page.click('[data-testid="search-button"]')
  }

  async getResults() {
    return this.page.locator('[data-testid="patient-row"]').allTextContents()
  }

  async clickPatient(name: string) {
    await this.page.click(`text=${name}`)
  }
}

// Usage in test
test('should find patient by name', async ({ page }) => {
  const patientList = new PatientListPage(page)
  await patientList.goto()
  await patientList.search('DUPONT')

  const results = await patientList.getResults()
  expect(results).toContain('DUPONT JEAN')
})
```

### Data-testid Convention

Use `data-testid` attributes for test selectors, never CSS classes or element structure:

```typescript
// GOOD — stable selector
await page.click('[data-testid="submit-admission"]')

// BAD — brittle, breaks on style/structure changes
await page.click('.btn.btn-primary.submit')
await page.click('form > div:nth-child(3) > button')
```

### Visual Regression Testing

```typescript
test('patient dashboard matches snapshot', async ({ page }) => {
  await page.goto('/dashboard')
  await page.waitForLoadState('networkidle')
  await expect(page).toHaveScreenshot('dashboard.png', {
    maxDiffPixelRatio: 0.01,
  })
})
```

## 4. Mocking Strategies

### When to Mock

| Mock | Don't Mock |
|------|------------|
| External HTTP APIs | Your own database (use real test DB) |
| Time/Date (for determinism) | Internal collaborators between modules |
| File system (when impractical) | Simple utility functions |
| Third-party services (payment, email) | Data transformations |
| Environment-specific features | Business logic |

### Mock vs Stub vs Spy

```typescript
// STUB — returns a fixed value
const getPatient = vi.fn().mockResolvedValue({ id: 'PAT123', name: 'DUPONT' })

// SPY — observes calls without changing behavior
const logSpy = vi.spyOn(logger, 'info')
await service.admitPatient(data)
expect(logSpy).toHaveBeenCalledWith('Patient admitted', { id: 'PAT123' })

// MOCK — replaces the entire module
vi.mock('./emailService', () => ({
  sendAdmissionNotification: vi.fn().mockResolvedValue(true),
}))
```

### MSW for HTTP Mocking

Prefer MSW (Mock Service Worker) over manual fetch mocking:

```typescript
import { http, HttpResponse } from 'msw'
import { setupServer } from 'msw/node'

const server = setupServer(
  http.get('/api/patients/:id', ({ params }) => {
    return HttpResponse.json({
      id: params.id,
      name: 'DUPONT',
      birthDate: '1975-03-15',
    })
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
```

### Time Mocking

```typescript
describe('token expiration', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  it('should reject expired tokens', () => {
    const token = createToken({ expiresIn: '1h' })

    vi.advanceTimersByTime(2 * 60 * 60 * 1000)  // 2 hours later

    expect(() => validateToken(token)).toThrow('Token expired')
  })
})
```

## 5. Test Organization

### File Structure — Colocation

```
src/
├── patients/
│   ├── PatientService.ts
│   ├── PatientService.test.ts      # Unit tests next to source
│   ├── PatientRepository.ts
│   └── PatientRepository.test.ts
├── __tests__/
│   └── integration/
│       ├── patient-admission.test.ts    # Integration tests
│       └── hl7-message-flow.test.ts
└── e2e/
    ├── patient-workflow.spec.ts    # E2E tests
    └── pages/
        └── PatientListPage.ts     # Page objects
```

### Test Utilities — Factories

Avoid copy-pasting test data. Use factories:

```typescript
// test/factories/patient.ts
export function buildPatient(overrides: Partial<Patient> = {}): Patient {
  return {
    id: `PAT${Math.random().toString(36).slice(2, 8)}`,
    name: 'DUPONT',
    firstName: 'JEAN',
    birthDate: '1975-03-15',
    sex: 'M',
    ...overrides,
  }
}

// Usage
it('should flag underage patients', () => {
  const minor = buildPatient({ birthDate: '2015-06-01' })
  expect(isMinor(minor)).toBe(true)
})
```

## 6. Common Anti-Patterns

### Testing Implementation Details

```typescript
// BAD — tests internal state
it('should set isLoading to true', () => {
  component.fetchData()
  expect(component.state.isLoading).toBe(true)
})

// GOOD — tests observable behavior
it('should show loading spinner while fetching', async () => {
  render(<PatientList />)
  expect(screen.getByTestId('spinner')).toBeVisible()
  await waitForElementToBeRemoved(screen.queryByTestId('spinner'))
})
```

### Excessive Mocking

```typescript
// BAD — mocking everything, testing nothing real
it('should create patient', async () => {
  vi.mock('./db')
  vi.mock('./validator')
  vi.mock('./logger')
  // ... what are you even testing?
})

// GOOD — use real implementations, mock only boundaries
it('should create patient in database', async () => {
  const repo = new PatientRepository(testDb)
  const service = new PatientService(repo)  // Real repo, real DB

  const patient = await service.create({ name: 'DUPONT' })
  expect(patient.id).toBeDefined()
})
```

### Flaky Test Patterns

Common causes and fixes:

| Cause | Fix |
|-------|-----|
| Shared mutable state | Use `beforeEach` to reset state |
| Time-dependent tests | Use `vi.useFakeTimers()` |
| Race conditions in async tests | Use `waitFor` / `findBy` instead of `getBy` |
| Order-dependent tests | Each test must be independent |
| Network calls in unit tests | Mock HTTP with MSW |
| Hardcoded ports | Use dynamic port assignment |

### Snapshot Overuse

```typescript
// BAD — meaningless snapshot of entire component
it('should render', () => {
  const { container } = render(<PatientCard patient={patient} />)
  expect(container).toMatchSnapshot()  // 200 lines of HTML nobody reads
})

// GOOD — targeted assertions
it('should display patient name and birthdate', () => {
  render(<PatientCard patient={patient} />)
  expect(screen.getByText('DUPONT JEAN')).toBeVisible()
  expect(screen.getByText('15/03/1975')).toBeVisible()
})
```

## 7. Testing Checklist

Before submitting a PR, verify:

```
[ ] New feature has tests covering happy path and error cases
[ ] Tests are independent — can run in any order
[ ] No flaky tests introduced (run suite 3x to verify)
[ ] Test names describe behavior, not implementation
[ ] Mocks are limited to external boundaries
[ ] No hardcoded test data — using factories
[ ] Test utilities are shared, not duplicated
[ ] Integration tests clean up after themselves
[ ] E2E tests use data-testid selectors
[ ] Coverage hasn't decreased
```

## Framework Quick Reference

| Framework | Best For | Command |
|-----------|----------|---------|
| **Vitest** | Unit + integration (Vite projects) | `vitest run` |
| **Jest** | Unit + integration (legacy, CRA) | `jest --coverage` |
| **Playwright** | E2E, visual regression | `playwright test` |
| **Cypress** | E2E, component testing | `cypress run` |
| **Testing Library** | DOM testing (React, Vue) | Used with Vitest/Jest |
| **MSW** | HTTP mocking | Used with any runner |
