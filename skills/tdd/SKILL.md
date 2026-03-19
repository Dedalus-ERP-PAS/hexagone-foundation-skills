---
name: tdd
description: "Développement piloté par les tests avec boucle red-green-refactor. À utiliser quand l'utilisateur veut construire des fonctionnalités ou corriger des bugs en TDD, mentionne « red-green-refactor », veut des tests d'intégration ou demande du développement test-first."
version: 1.0.0
license: MIT
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests should not.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_. A good test reads like a specification. These tests survive refactors because they don't depend on internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means. Warning sign: your test breaks when you refactor, but behavior hasn't changed.

See [reference/tests.md](reference/tests.md) for examples and [reference/mocking.md](reference/mocking.md) for mocking guidelines.

## Framework Agnostic

This skill works with any test framework (Vitest, Jest, Playwright, Cypress, pytest, JUnit, etc.) and any stack (Vue.js, React, Node.js, backend services). Adapt examples to the project's language and framework.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" — treating RED as "write all tests" and GREEN as "write all code."

This produces poor tests: they test _imagined_ behavior, test the _shape_ of things rather than user-facing behavior, and become insensitive to real changes.

**Correct approach**: Vertical slices via tracer bullets. One test, one implementation, repeat.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

## Workflow

### 1. Planning

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm which behaviors to test (prioritize — you can't test everything)
- [ ] Identify opportunities for [deep modules](reference/deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](reference/interface-design.md)
- [ ] List behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

### 2. Tracer Bullet

Write ONE test that confirms ONE thing — proves the path works end-to-end:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

### 3. Incremental Loop

For each remaining behavior: `RED → GREEN`, one test at a time.

- Only enough code to pass the current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for [refactor candidates](reference/refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive an internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
