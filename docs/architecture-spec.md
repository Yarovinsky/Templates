# Architecture Specification

## Technology Stack

| Concern | Choice | Notes |
|---------|--------|-------|
| **Language** | TypeScript 5.x | Strict mode enabled |
| **Runtime** | Node.js 20 LTS | |
| **Framework** | Express 4.x | REST API |
| **ORM / DB client** | Prisma 5.x | |
| **Database** | PostgreSQL 16 | |
| **Test runner** | Vitest 1.x | |
| **Assertion library** | Vitest built-in (`expect`) | |
| **HTTP test client** | Supertest | For integration tests |
| **Mock library** | Vitest (`vi.fn()`, `vi.mock()`) | |
| **Linter** | ESLint + typescript-eslint | |
| **Formatter** | Prettier | |
| **Package manager** | pnpm | |

---

## How to Run the Test Suite

### Roo Mode Command (mandatory for Roo agents)

```powershell
# Default timeout (1 minute)
powershell -NoProfile -ExecutionPolicy Bypass -File .\.roo\scripts\run-tests.ps1 -Command "pnpm test"

# Override timeout (example: 5 minutes)
powershell -NoProfile -ExecutionPolicy Bypass -File .\.roo\scripts\run-tests.ps1 -Command "pnpm test" -TimeoutMinutes 5
```

### Direct Commands (manual/local use)

```bash
# Run all tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run tests with coverage
pnpm test:coverage

# Run a single test file
pnpm test src/auth/register.test.ts
```

---

## Project Directory Structure

```
src/
  auth/                    # Authentication module
    register.ts
    login.ts
    register.test.ts       # Co-located unit tests
    login.test.ts
  users/                   # User management module
    userService.ts
    userRepository.ts
    userService.test.ts
  tasks/                   # Task management module
    taskService.ts
    taskRepository.ts
    taskService.test.ts
  projects/                # Project grouping module
    projectService.ts
    projectRepository.ts
    projectService.test.ts
  shared/                  # Shared utilities and types
    errors.ts
    types.ts
    validators.ts
  app.ts                   # Express app setup
  server.ts                # Entry point

tests/
  integration/             # Integration tests (multi-layer)
    auth.integration.test.ts
    tasks.integration.test.ts
  e2e/                     # End-to-end tests (full stack)
    taskflow.e2e.test.ts

prisma/
  schema.prisma
  migrations/
```

---

## Test File Naming Conventions

| Test Type | Pattern | Example |
|-----------|---------|---------|
| Unit test | `<module>.test.ts` | `taskService.test.ts` |
| Integration test | `<feature>.integration.test.ts` | `tasks.integration.test.ts` |
| End-to-end test | `<flow>.e2e.test.ts` | `taskflow.e2e.test.ts` |

**Rule:** Unit tests are co-located with the source file they test (e.g. `src/tasks/taskService.test.ts` sits next to `src/tasks/taskService.ts`).

---

## Skip Marker Syntax

When in the Red phase, use this skip syntax:

```typescript
// Vitest / Jest
test.skip('scenario description', () => { ... })
it.skip('scenario description', () => { ... })
```

---

## Layer Architecture

```
HTTP Layer (Express routes)
    ↓
Service Layer (business logic — all TDD tests target this layer primarily)
    ↓
Repository Layer (database access via Prisma)
    ↓
Database (PostgreSQL)
```

**Rules:**
- Services must not import from routes.
- Repositories must not contain business logic.
- Tests for service logic must mock the repository layer.
- Integration tests may test route → service → repository together using a test database.

---

## Naming Conventions

| Concept | Convention | Example |
|---------|------------|---------|
| Files | `camelCase.ts` | `taskService.ts` |
| Classes | `PascalCase` | `TaskService` |
| Functions / methods | `camelCase` | `createTask()` |
| Constants | `SCREAMING_SNAKE_CASE` | `TOKEN_EXPIRY_SECONDS` |
| Test files | `<source-file>.test.ts` | `taskService.test.ts` |
| Test descriptions | Match the Given/When/Then scenario name | `"returns 404 when task does not exist"` |

---

## Environment Setup

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env
# Edit .env with your local DB credentials

# Run database migrations
pnpm prisma migrate dev

# Seed the database (development only)
pnpm prisma db seed
```

---

## External Dependencies

| Dependency | Purpose | Notes |
|------------|---------|-------|
| PostgreSQL | Primary data store | Run via Docker locally |
| bcrypt | Password hashing | Used in auth module |
| jsonwebtoken | JWT issuance and verification | Requires `JWT_SECRET` in `.env` |
