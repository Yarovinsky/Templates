# 06 — Naming Conventions

> **Status**: Normative
> **Audience**: All skill modes
> **Purpose**: Define mandatory naming rules for all code, test, and documentation artifacts

---

## 1. Authority

These naming rules are **MANDATORY** and **enforceable**. All code, test, and documentation artifacts MUST comply. The Refactorer skill verifies naming alignment during Phase 6.

Violations detected during any phase must be corrected before the phase can complete. The Validator skill checks naming compliance as part of quality gate enforcement in Phase 7.

---

## 2. Bounded Contexts

**Convention**: PascalCase nouns matching ubiquitous language terms.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `OrderManagement` | `order_management` |
| `InventoryControl` | `inventoryControl` |
| `UserAuthentication` | `User_Auth` |

- Must match a term in the ubiquitous language glossary
- Name should describe the business capability, not a technical concern

---

## 3. Aggregates

**Convention**: PascalCase nouns with **NO** redundant suffix (no `Aggregate` suffix).

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `Order` | `OrderAggregate` |
| `Product` | `ProductAgg` |
| `Customer` | `CustomerRoot` |

- The aggregate IS the concept; suffixing is redundant
- Name must correspond to a domain concept in the glossary

---

## 4. Entities

**Convention**: PascalCase nouns.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `OrderLine` | `order_line` |
| `Address` | `addressEntity` |
| `PaymentMethod` | `payment_method` |

- Name must reflect the domain concept
- Must be distinguishable from the aggregate root it belongs to

---

## 5. Value Objects

**Convention**: PascalCase nouns.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `Money` | `MoneyVO` |
| `EmailAddress` | `email_address` |
| `DateRange` | `DateRangeValueObject` |

- Name describes the value being modeled
- No type-indicating suffixes (`VO`, `ValueObject`, etc.)

---

## 6. Domain Events

**Convention**: Past-tense verb phrases in PascalCase.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `OrderPlaced` | `PlaceOrder` |
| `PaymentProcessed` | `PaymentProcess` |
| `InventoryReserved` | `ReserveInventory` |

- Must indicate something that **HAS** happened (past tense)
- Should read naturally as a sentence: "An OrderPlaced event occurred"

---

## 7. Repository Interfaces

**Convention**: `I` prefix + aggregate root name + `Repository`.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `IOrderRepository` | `OrderRepo` |
| `ICustomerRepository` | `CustomerRepository` (missing `I` prefix) |
| `IProductRepository` | `IProductRepo` |

- Only aggregate roots have repositories
- The `I` prefix denotes an interface (contract), not an implementation
- Implementation classes drop the `I` prefix (e.g., `SqlOrderRepository`)

---

## 8. Domain Services

**Convention**: PascalCase verb-noun phrases.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `TransferFundsService` | `FundsTransferrer` |
| `CalculateShippingService` | `ShippingCalc` |
| `ValidateOrderService` | `OrderValidator` |

- Name indicates the action being performed across aggregates
- The `Service` suffix is required to distinguish from entities and value objects

---

## 9. Application Services

**Convention**: PascalCase use-case name + `ApplicationService`.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `PlaceOrderApplicationService` | `PlaceOrderService` |
| `ProcessPaymentApplicationService` | `PaymentProcessor` |

- Maps 1:1 to HLD feature narratives
- The `ApplicationService` suffix distinguishes from domain services

---

## 10. Test Files

**Convention**: Mirror the production file path structure with `Test` or `Spec` suffix.

| Production File | Test File |
|-----------------|-----------|
| `src/OrderManagement/Order.ext` | `tests/unit/OrderManagement/OrderTest.ext` |
| `src/OrderManagement/Order.ext` | `tests/unit/OrderManagement/OrderSpec.ext` |
| `src/OrderManagement/Domain/ValueObjects/Money.ext` | `tests/unit/OrderManagement/Domain/ValueObjects/MoneyTest.ext` |

- Technology-specific extensions apply (`.cs`, `.ts`, `.java`, `.py`, etc.)
- The test directory structure must mirror the `src/` structure
- Both `Test` and `Spec` suffixes are acceptable; choose one per project and be consistent

---

## 11. Test Methods

**Convention**: `should_ExpectedBehavior_When_Condition`

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `should_RejectOrder_When_TotalExceedsCreditLimit` | `testRejectOrder` |
| `should_CalculateTotal_When_MultipleLineItemsExist` | `calcTotalMultipleItems` |
| `should_EmitOrderPlacedEvent_When_OrderIsValid` | `test_order_placed` |

- Use underscores for readability
- The `should` prefix makes tests read as specifications
- `When` clause describes the precondition or trigger
- Each test method tests a single logical behavior

---

## 12. File Organization

Organize source files by bounded context following this structure:

```
src/
├── {BoundedContextName}/
│   ├── Domain/
│   │   ├── Aggregates/
│   │   ├── Entities/
│   │   ├── ValueObjects/
│   │   ├── Events/
│   │   ├── Services/
│   │   └── Repositories/    (interfaces only)
│   ├── Application/
│   │   └── Services/
│   └── Infrastructure/
│       ├── Persistence/     (repository implementations)
│       └── Adapters/
```

**Rules**:
- Each bounded context is a top-level directory under `src/`
- Domain layer contains only domain logic — no infrastructure concerns
- `Repositories/` under Domain contains only interfaces
- Repository implementations go in `Infrastructure/Persistence/`
- External system integrations go in `Infrastructure/Adapters/`

---

## 13. Documentation Files

**Convention**: All lowercase with hyphens for spaces (kebab-case).

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `validated-hld.md` | `ValidatedHLD.md` |
| `context-map.md` | `context_map.md` |
| `tech-debt-register.md` | `TechDebtRegister.md` |

**Exception**: ADRs use the format `ADR-NNN-title-in-kebab-case.md`

| ✅ Correct |
|-----------|
| `ADR-001-aggregate-persistence-strategy.md` |
| `ADR-002-event-serialization-format.md` |

---

## 14. State and Configuration Files

**Convention**: JSON format, kebab-case filenames.

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `phase-state.json` | `phaseState.json` |
| `quality-gates.json` | `quality_gates.json` |
| `phase-1-complete.json` | `Phase1Complete.json` |
| `audit.jsonl` | `Audit.jsonl` |
