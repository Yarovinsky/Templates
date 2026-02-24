# Story: 001 — User Registration

---

## Status

- [x] Spec written
- [x] Red (tests written + confirmed failing + skipped)
- [ ] Green (tests passing)
- [ ] Refactor (code cleaned up)
- [ ] Committed & tagged

---

## Metadata

| Field | Value |
|-------|-------|
| **Story #** | 001 |
| **Priority** | 🔴 High |
| **Estimate** | M |
| **Depends on** | — |

---

## User Story

> As a **new user (The Developer)**,
> I want **to register with my email and password**,
> so that **I can create a TaskFlow account and start making authenticated API calls**.

---

## Acceptance Criteria

- [x] AC1: A user can register with a valid email and a password that meets complexity requirements, and receives a success response.
- [x] AC2: Registration fails with a clear error when the email is already in use.
- [x] AC3: Registration fails with a clear error when the password does not meet complexity requirements (min 8 chars, at least one number).
- [x] AC4: Registration fails with a clear error when the email format is invalid.
- [x] AC5: The password is never stored in plain text — it is hashed before persistence.

---

## Scope

### In Scope
- `POST /auth/register` endpoint accepting `{ email, password }`.
- Validation of email format and password complexity.
- Hashing the password using bcrypt before storing.
- Returning `201 Created` with `{ id, email, createdAt }` on success.
- Returning `409 Conflict` when email already exists.
- Returning `422 Unprocessable Entity` when validation fails, with a descriptive error array.

### Out of Scope
- Email verification / confirmation flow (future story)
- OAuth / social login (out of scope for entire product — see `docs/product-definition.md`)
- Password strength meter
- Welcome email on registration (future story)

---

## Technical Notes

- **Affected modules/files:**
  - `src/auth/register.ts` (new — service logic)
  - `src/auth/register.test.ts` (new — unit tests)
  - `src/users/userRepository.ts` (may need `createUser` method)
  - `src/shared/types.ts` (add `RegisterRequest`, `RegisterResponse` types)

- **Dependencies/mocks needed:**
  - Mock `userRepository.findByEmail` to control "email exists" scenario.
  - Mock `userRepository.createUser` to avoid real DB in unit tests.
  - Use `bcrypt` for password hashing — mock it in unit tests for speed.

- **Key types/interfaces:**
  ```typescript
  interface RegisterRequest {
    email: string;
    password: string;
  }

  interface RegisterResponse {
    id: string;
    email: string;
    createdAt: string; // ISO 8601
  }
  ```

- **Edge cases to test:**
  - Password exactly 8 chars (boundary — should pass)
  - Password 7 chars (boundary — should fail)
  - Password with no numbers (should fail)
  - Email with valid format but uppercase letters (should normalise to lowercase)
  - Email with leading/trailing whitespace (should be trimmed)

- **Error response format:**
  ```json
  {
    "error": "Validation failed",
    "details": [
      { "field": "password", "message": "Password must be at least 8 characters" }
    ]
  }
  ```

---

## Demonstrability

**Run command:**
```bash
# 1. Start the API server
pnpm dev

# 2. Register a new user
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "demo@example.com", "password": "demo1234"}'
```

**Expected observable output:**
```json
HTTP/1.1 201 Created

{
  "id": "a3f1c2d4-...",
  "email": "demo@example.com",
  "createdAt": "2024-01-15T10:30:00.000Z"
}
```

**Prerequisites to run:**
- [x] API server running locally (`pnpm dev`)
- [x] PostgreSQL running and migrated (`pnpm prisma migrate dev`)
- [x] `.env` file configured with `DATABASE_URL`

---

## Test Scenarios

> Populated by `tdd-spec` during the Spec phase.

### Scenario 1: Successful registration
- **Given** a new user with a valid email `"alex@example.com"` and a valid password `"secure123"`
- **When** `POST /auth/register` is called with `{ email: "alex@example.com", password: "secure123" }`
- **Then** the response status is `201`
- **And** the response body contains `{ id: <uuid>, email: "alex@example.com", createdAt: <ISO date> }`
- **And** the password stored in the database is NOT equal to `"secure123"` (it is hashed)

### Scenario 2: Duplicate email
- **Given** a user with email `"alex@example.com"` already exists in the system
- **When** `POST /auth/register` is called with `{ email: "alex@example.com", password: "newpass456" }`
- **Then** the response status is `409`
- **And** the response body contains `{ error: "Email already in use" }`

### Scenario 3: Password too short
- **Given** a new user with a valid email and a password with only 7 characters `"short1x"`
- **When** `POST /auth/register` is called
- **Then** the response status is `422`
- **And** the response body contains a details array with a field `"password"` error

### Scenario 4: Password contains no numbers
- **Given** a new user with a valid email and a password `"onlyletters"`
- **When** `POST /auth/register` is called
- **Then** the response status is `422`
- **And** the response body contains a details array with a field `"password"` error

### Scenario 5: Invalid email format
- **Given** a new user with an invalid email `"not-an-email"` and a valid password
- **When** `POST /auth/register` is called
- **Then** the response status is `422`
- **And** the response body contains a details array with a field `"email"` error

### Scenario 6: Email normalisation
- **Given** a new user with email `"  Alex@Example.COM  "` (with spaces and mixed case) and a valid password
- **When** `POST /auth/register` is called
- **Then** the account is created with email `"alex@example.com"` (lowercased and trimmed)

---

## Git Tag

`story/001-user-registration`
