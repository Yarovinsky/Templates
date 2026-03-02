# 02 — DDD Transformation Pipeline

> **Framework Document**: 02 of 10  
> **Authority**: [00-overview.md](00-overview.md)  
> **Phase Association**: Phase 2 (Strategic Domain Modeling) and Phase 3 (Tactical Domain Modeling)

---

## 1. Pipeline Overview

This document defines the **deterministic sequence** Roo MUST follow to decompose a Validated HLD (produced by [01-hld-input-contract.md](01-hld-input-contract.md)) into a complete DDD model. The pipeline consists of 11 steps executed in strict order.

**Rules:**
- No step may be skipped or reordered
- Each step's output is the input to the next step
- Every artifact produced MUST carry at least one `[HLD-REQ-NNN]` traceability tag (see Section 13)
- The Analyst mode executes Steps 1–4 (strategic modeling); the DDD Architect mode executes Steps 5–11 (tactical modeling)
- The Orchestrator validates outputs at phase boundaries before advancing

---

## 2. Step 1: Extract Ubiquitous Language

**Input**: Validated HLD artifact  
**Output**: Ubiquitous Language Glossary  
**Executor**: Analyst mode

### Procedure:

1. Scan the entire Validated HLD for **domain-specific nouns, verbs, and phrases**
2. Extract terms **VERBATIM** — do not paraphrase, rename, abbreviate, or "improve" any term
3. For each extracted term, create a glossary entry:

| Field            | Description                                                    |
|------------------|----------------------------------------------------------------|
| **Term**         | The exact term as it appears in the HLD                        |
| **Source Section** | Which HLD section(s) the term appears in (BG, UP, FN, NFR, IP, DC) |
| **Definition**   | The meaning of the term as used in the HLD context             |
| **Related Terms** | Other glossary terms that are semantically connected           |
| **Consistency Flag** | `consistent` or `inconsistent` — see below                |

4. **Flag inconsistencies**: If a term appears with different meanings in different sections, mark it as `inconsistent` and document each meaning with its source section. Inconsistent terms MUST be resolved before bounded context delineation in Step 3.

### Glossary Format:

```markdown
## Ubiquitous Language Glossary

| Term | Source | Definition | Related Terms | Consistency |
|------|--------|------------|---------------|-------------|
| [term] | [HLD-BG-001], [HLD-FN-003] | [definition] | [related] | consistent |
```

---

## 3. Step 2: Identify and Name Domains

**Input**: Validated HLD + Ubiquitous Language Glossary  
**Output**: Domain inventory with HLD requirement mappings  
**Executor**: Analyst mode

### Procedure:

1. Group related HLD requirements by **business capability** — requirements that serve the same business function belong to the same domain
2. Name each domain using **ubiquitous language terms** extracted in Step 1 — do not invent new names
3. Verify that each domain traces to **at least one** `[HLD-REQ-NNN]` requirement
4. Document each domain:

| Field               | Description                                                    |
|----------------------|----------------------------------------------------------------|
| **Domain Name**      | PascalCase name derived from ubiquitous language               |
| **Purpose**          | One-paragraph description of the business capability           |
| **Scope**            | What this domain is responsible for (in-scope)                 |
| **Key Responsibilities** | Numbered list of core responsibilities                    |
| **HLD Requirements** | List of `[HLD-REQ-NNN]` tags this domain addresses            |

### Validation:

- Every `[HLD-REQ-NNN]` tag MUST be assigned to at least one domain
- No requirement may be orphaned (not assigned to any domain)
- If a requirement spans multiple domains, it must be listed in all applicable domains with a note about the cross-domain nature

---

## 4. Step 3: Delineate Bounded Contexts

**Input**: Domain inventory + Ubiquitous Language Glossary  
**Output**: Bounded context definitions with explicit scope boundaries  
**Executor**: Analyst mode

### Procedure:

1. Within each domain, identify **linguistic boundaries** — points where terms change meaning or where different sub-models apply
2. Define bounded context boundaries with **explicit in/out scope statements**
3. Each bounded context MUST have:

| Field                       | Description                                                  |
|-----------------------------|--------------------------------------------------------------|
| **Name**                    | PascalCase, derived from ubiquitous language                 |
| **Owning Domain**           | The domain this bounded context belongs to                   |
| **Purpose**                 | What this bounded context encapsulates                       |
| **In-Scope**                | Explicit list of concepts, behaviors, and rules included     |
| **Out-of-Scope**            | Explicit list of what is NOT part of this context            |
| **Key Aggregates (preliminary)** | Initial identification of likely aggregates            |
| **Upstream Dependencies**   | Bounded contexts this context depends on                     |
| **Downstream Dependencies** | Bounded contexts that depend on this context                 |
| **HLD Requirements**        | List of `[HLD-REQ-NNN]` tags                                |

### Rules:

- A bounded context may belong to exactly one domain
- The same ubiquitous language term appearing with different meanings in two bounded contexts confirms a correct boundary
- If no linguistic boundary exists within a domain, the entire domain may be a single bounded context

---

## 5. Step 4: Create Context Maps

**Input**: Bounded context definitions  
**Output**: Context map documenting all inter-context relationships  
**Executor**: Analyst mode

### Procedure:

For every **pair** of bounded contexts that interact, define the relationship using one of the following types:

### Relationship Types:

#### Shared Kernel
- Two bounded contexts share a subset of the model
- Both teams maintain the shared artifacts
- **Specify**: exact list of shared types, entities, or value objects
- **Risk**: tight coupling — changes to shared elements affect both contexts

#### Customer-Supplier
- Upstream context supplies data/services, downstream context consumes
- **Specify**: the contract (API, data format, SLA) the upstream commits to
- **Specify**: the downstream's delivery expectations and fallback behavior

#### Anticorruption Layer (ACL)
- Translation layer protecting the downstream context from upstream model pollution
- **Specify**: translation rules mapping upstream concepts to downstream ubiquitous language
- **Specify**: where the ACL resides (downstream context boundary)

#### Conformist
- Downstream adopts the upstream model without translation
- **Document**: rationale for why a conformist approach is acceptable (e.g., upstream is a standard, cost of ACL outweighs benefit)

#### Open Host Service
- Published API with a well-defined protocol exposed by a bounded context
- **Specify**: API contract (endpoints, methods, request/response schemas)
- **Specify**: versioning strategy

#### Published Language
- Shared interchange format used between contexts
- **Specify**: schema definition (JSON Schema, Protobuf, Avro, XSD, etc.)
- **Specify**: versioning and evolution strategy

### Relationship Documentation:

Each relationship MUST be documented with:

| Field                  | Description                                                |
|------------------------|------------------------------------------------------------|
| **Source Context**     | The bounded context initiating the interaction             |
| **Target Context**     | The bounded context receiving/responding                   |
| **Relationship Type**  | One of the 6 types above                                   |
| **Integration Mechanism** | How the contexts communicate (sync API, async events, shared DB, etc.) |
| **Data Flow Direction** | Upstream → Downstream, Bidirectional, or Event-driven     |
| **HLD Requirements**   | `[HLD-REQ-NNN]` tags driving this relationship            |

---

## 6. Step 5: Define Aggregates

**Input**: Bounded context definitions + context maps  
**Output**: Aggregate specifications per bounded context  
**Executor**: DDD Architect mode

### Procedure:

For each bounded context, identify aggregates. Each aggregate MUST specify:

| Field                   | Description                                                  |
|-------------------------|--------------------------------------------------------------|
| **Name**                | PascalCase, no suffix (e.g., `Order`, not `OrderAggregate`)  |
| **Aggregate Root Entity** | The single entity that serves as the entry point           |
| **Bounded Context**     | The context this aggregate belongs to                        |
| **Invariants**          | Numbered list of business rules that MUST always hold        |
| **Consistency Boundary** | What is guaranteed to be consistent within a single transaction |
| **Commands**            | List of commands (actions) this aggregate handles            |
| **Events**              | List of domain events this aggregate emits                   |
| **Traceability**        | `[HLD-REQ-NNN]` tags                                        |

### Invariant Specification:

Each invariant MUST be stated as a testable boolean condition:

```
INV-001: Order.TotalAmount MUST equal the sum of all OrderLine.Amount values
INV-002: Order MUST have at least one OrderLine before it can be submitted
INV-003: Order.Status transitions MUST follow: Draft → Submitted → Confirmed → Shipped → Delivered
```

### Consistency Boundary Rules:

- All entities and value objects within an aggregate are **guaranteed consistent** within a single transaction
- Cross-aggregate references use **identity references only** (IDs, not object references)
- Cross-aggregate consistency is **eventual**, not transactional

---

## 7. Step 6: Define Entities

**Input**: Aggregate specifications  
**Output**: Entity specifications per aggregate  
**Executor**: DDD Architect mode

### Procedure:

For each entity within an aggregate, specify:

| Field                | Description                                                    |
|----------------------|----------------------------------------------------------------|
| **Name**             | PascalCase (e.g., `OrderLine`, `Customer`)                     |
| **Aggregate**        | The aggregate this entity belongs to                           |
| **Identity Rule**    | What makes two instances the same entity                       |
| **Identity Type**    | Natural key / Surrogate key / Composite key                    |
| **Properties**       | List of properties with types and constraints                  |
| **Lifecycle States** | State machine definition (if applicable)                       |
| **Relationships**    | Relationships to other entities within the same aggregate      |
| **Traceability**     | `[HLD-REQ-NNN]` tags                                          |

### Identity Rule Examples:

- **Natural key**: `Customer` is identified by `Email` (business-meaningful identifier)
- **Surrogate key**: `Order` is identified by `OrderId` (system-generated UUID)
- **Composite key**: `OrderLine` is identified by `(OrderId, ProductId)` pair

### Lifecycle State Machine (when applicable):

```
[State A] --event1--> [State B] --event2--> [State C]
                                --event3--> [State D]
```

Document:
- All valid states
- All valid transitions (source state → event → target state)
- Invalid transitions (explicitly forbidden)
- Terminal states (no outgoing transitions)

---

## 8. Step 7: Define Value Objects

**Input**: Aggregate and entity specifications  
**Output**: Value object specifications  
**Executor**: DDD Architect mode

### Procedure:

For each value object, specify:

| Field                  | Description                                                  |
|------------------------|--------------------------------------------------------------|
| **Name**               | PascalCase (e.g., `Money`, `Address`, `EmailAddress`)        |
| **Aggregate**          | The aggregate this value object belongs to                   |
| **Properties**         | All properties — every property is immutable                 |
| **Immutability Contract** | Once created, no property may change; new instances must be created for modifications |
| **Equality Semantics** | Two instances are equal if and only if ALL properties are equal |
| **Validation Rules**   | What constitutes a valid instance (constructor invariants)    |
| **Traceability**       | `[HLD-REQ-NNN]` tags                                        |

### Immutability Contract:

Value objects MUST enforce:
- No public setters
- All properties set at construction time
- Any "modification" returns a **new instance** (e.g., `money.Add(other)` returns a new `Money`, does not mutate `this`)
- Thread-safe by construction

### Equality Semantics:

- `Equals(a, b)` returns `true` if and only if every property of `a` equals the corresponding property of `b`
- `GetHashCode()` is derived from all properties
- No identity — two `Money(100, "USD")` instances are interchangeable

---

## 9. Step 8: Define Domain Events

**Input**: Aggregate specifications (commands and events lists)  
**Output**: Domain event specifications with schemas and causality chains  
**Executor**: DDD Architect mode

### Procedure:

For each domain event, specify:

| Field              | Description                                                    |
|--------------------|----------------------------------------------------------------|
| **Name**           | Past-tense verb phrase in PascalCase (e.g., `OrderPlaced`, `PaymentProcessed`) |
| **Source Aggregate** | The aggregate that emits this event                          |
| **Bounded Context** | The context where this event originates                       |
| **Schema**         | All properties with types                                      |
| **Causality Chain** | What triggers this event and what downstream reactions it causes |
| **Traceability**   | `[HLD-REQ-NNN]` tags                                          |

### Schema Specification:

```
OrderPlaced:
  - orderId: UUID (required)
  - customerId: UUID (required)
  - orderLines: List<OrderLineSnapshot> (required, min: 1)
  - totalAmount: Money (required)
  - placedAt: DateTime (required, ISO 8601)
```

### Causality Chain:

Document the full cause-and-effect chain:

```
Trigger: PlaceOrder command on Order aggregate
  → Emits: OrderPlaced event
    → Reaction 1: InventoryContext reserves stock (InventoryReserved or InsufficientStock)
    → Reaction 2: NotificationContext sends order confirmation email
    → Reaction 3: BillingContext initiates payment processing
```

---

## 10. Step 9: Define Repository Interfaces

**Input**: Aggregate specifications  
**Output**: Repository interface contracts  
**Executor**: DDD Architect mode

### Procedure:

For each aggregate root, define a repository interface:

| Field                    | Description                                                |
|--------------------------|------------------------------------------------------------|
| **Name**                 | `I` + aggregate name + `Repository` (e.g., `IOrderRepository`) |
| **Aggregate Root**       | The aggregate root this repository manages                 |
| **Bounded Context**      | The context this repository belongs to                     |
| **Query Contracts**      | Methods with input parameters and return types             |
| **Persistence Ignorance** | No technology-specific types in the interface             |
| **Traceability**         | `[HLD-REQ-NNN]` tags                                      |

### Rules:

- Repositories exist **only for aggregate roots**, never for child entities or value objects
- Repository interfaces belong to the **domain layer**, not the infrastructure layer
- No technology-specific types (no `DbConnection`, no `IQueryable`, no `SqlCommand`)
- Return domain types only (aggregates, entities, value objects, or collections thereof)

### Standard Methods:

Every repository SHOULD define at minimum:

```
FindById(id: AggregateIdType) → Aggregate | null
Save(aggregate: Aggregate) → void
Delete(aggregate: Aggregate) → void
```

Additional query methods are defined based on the use cases derived from HLD feature narratives.

---

## 11. Step 10: Define Domain Services

**Input**: Aggregate specifications + use case analysis  
**Output**: Domain service specifications  
**Executor**: DDD Architect mode

### Procedure:

Domain services encapsulate logic that **spans multiple aggregates** within a single bounded context. If logic belongs to a single aggregate, it MUST be placed in the aggregate, not in a domain service.

For each domain service, specify:

| Field                 | Description                                                  |
|-----------------------|--------------------------------------------------------------|
| **Name**              | PascalCase verb-noun phrase (e.g., `TransferFundsService`, `ValidateOrderService`) |
| **Bounded Context**   | The context this service belongs to                          |
| **Responsibility**    | What cross-aggregate logic this service encapsulates         |
| **Input Contract**    | Parameters with types and validation rules                   |
| **Output Contract**   | Return type and possible outcomes (success/failure)          |
| **Aggregates Coordinated** | List of aggregates this service orchestrates            |
| **Traceability**      | `[HLD-REQ-NNN]` tags                                        |

### Rules:

- Domain services are **stateless** — they do not hold state between invocations
- Domain services operate within a **single bounded context** — cross-context logic belongs in application services
- Domain services may call repository interfaces to load/save aggregates
- Domain services enforce cross-aggregate business rules that cannot be placed in any single aggregate

---

## 12. Step 11: Define Application Services and Workflows

**Input**: HLD feature narratives + complete tactical model (aggregates, entities, VOs, events, repositories, domain services)  
**Output**: Application service specifications with workflow definitions  
**Executor**: DDD Architect mode

### Procedure:

For each HLD use case (feature narrative `[HLD-FN-NNN]`), define an application service:

| Field                     | Description                                                |
|---------------------------|------------------------------------------------------------|
| **Name**                  | Use-case name + `ApplicationService` (e.g., `PlaceOrderApplicationService`) |
| **Bounded Context**       | Primary context (may orchestrate across contexts)          |
| **Use Case**              | The HLD feature narrative this service implements          |
| **Workflow Steps**        | Numbered sequence of domain operations                     |
| **Orchestrated Aggregates** | Aggregates loaded, modified, or queried                  |
| **Orchestrated Domain Services** | Domain services invoked                             |
| **Transaction Boundaries** | Which steps are within the same transaction               |
| **Events Published**      | Domain events emitted during the workflow                  |
| **Traceability**          | Must map 1:1 to `[HLD-FN-NNN]`                            |

### Workflow Step Format:

```
Workflow: PlaceOrder

1. Load Customer aggregate by customerId        [Transaction A]
2. Validate customer is active                   [Transaction A]
3. Create Order aggregate with order lines       [Transaction A]
4. Apply pricing rules via PricingService        [Transaction A]
5. Save Order aggregate                          [Transaction A]
6. Publish OrderPlaced event                     [Transaction A - post-commit]
7. [Async] InventoryContext reserves stock       [Eventual consistency]
8. [Async] NotificationContext sends confirmation [Eventual consistency]
```

### Rules:

- Each application service maps to **exactly one** HLD feature narrative `[HLD-FN-NNN]`
- Application services may orchestrate across bounded contexts (via events or API calls)
- Application services define transaction boundaries explicitly
- Application services do NOT contain business logic — they orchestrate domain objects that contain the logic

---

## 13. Traceability Tag Mandate

**Every** DDD artifact produced by this pipeline MUST have at least one `[HLD-REQ-NNN]` traceability tag. This is a **non-negotiable** requirement.

### Covered Artifact Types:

| Artifact Type         | Traceability Requirement                                    |
|-----------------------|-------------------------------------------------------------|
| Domain                | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Bounded Context       | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Aggregate             | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Entity                | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Value Object          | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Domain Event          | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Repository Interface  | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Domain Service        | ≥ 1 `[HLD-REQ-NNN]` tag                                    |
| Application Service   | Exactly 1 `[HLD-FN-NNN]` tag (1:1 mapping to feature narrative) |

### Validation:

- **Artifacts without tags are INVALID** and must not proceed to the test specification phase
- The Orchestrator verifies traceability completeness at the Phase 2 → Phase 3 and Phase 3 → Phase 4 boundaries
- Orphaned HLD requirements (requirements not referenced by any DDD artifact) MUST be reported as gaps

---

## 14. Conflict Resolution Protocol

When DDD boundary purity conflicts with technical constraints (e.g., performance requirements forcing denormalization, infrastructure limitations requiring shared databases, legacy system integration requiring model compromises), follow this protocol:

### Step A: Document the Conflict

Clearly state:
- What DDD principle is being violated (e.g., aggregate boundary, bounded context isolation, persistence ignorance)
- What technical constraint forces the violation (with `[HLD-REQ-NNN]` reference)

### Step B: Propose Pragmatic Adjustment

Propose a boundary adjustment that minimizes contamination:
- Introduce an **Anticorruption Layer (ACL)** at the compromise point
- Define explicit translation rules in the ACL
- Isolate the compromise to the smallest possible surface area

### Step C: Log the Deviation

Record the deviation with the following structure:

| Field                    | Description                                                |
|--------------------------|------------------------------------------------------------|
| **Conflict ID**          | `CONFLICT-NNN` (sequential)                                |
| **DDD Principle Violated** | The specific principle being compromised                |
| **Technical Constraint** | The constraint forcing the compromise (`[HLD-REQ-NNN]`)   |
| **Proposed Adjustment**  | The pragmatic solution adopted                             |
| **ACL Specification**    | Translation rules and boundary protection measures         |
| **Rationale**            | Why this compromise is the least-damaging option           |
| **Tech Debt Ticket ID**  | `TECHDEBT-NNN` — for future remediation tracking           |
| **ADR Reference**        | Architecture Decision Record documenting this decision     |

### Rules:

- All conflicts MUST be recorded in the Architecture Decision Records (ADRs)
- Each conflict generates a tech debt ticket for future remediation
- The Orchestrator tracks all active conflicts and includes them in progress reports
- Conflicts do NOT block progress — they are documented compromises, not unresolved ambiguities
