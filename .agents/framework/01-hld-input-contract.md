# 01 — HLD Input Contract

> **Framework Document**: 01 of 10  
> **Authority**: [00-overview.md](00-overview.md)  
> **Phase Association**: Phase 1 — HLD Intake and Validation

---

## 1. Sole Input Artifact

The customer's draft **High-Level Design (HLD)** document is the **sole mandatory input** to this framework. No domain modeling, test specification, or development activity of any kind may begin without a received HLD document.

The HLD may be provided in any text-based format:

- Markdown (preferred)
- Plain text
- DOCX (must be converted to markdown before processing)
- PDF (must be converted to markdown before processing)

The Analyst mode is the only mode authorized to receive, parse, and validate the HLD.

---

## 2. Required HLD Sections

The HLD document MUST contain all 6 of the following sections. Each section has a defined structural expectation and a prefix for requirement IDs.

### 2.1 Business Goals (BG)

Numbered list of measurable business objectives. Each entry MUST have:

| Field            | Format            | Description                                                  |
|------------------|-------------------|--------------------------------------------------------------|
| **ID**           | `BG-NNN`          | Sequential numeric identifier (e.g., `BG-001`)              |
| **Description**  | Free text         | Clear statement of the business objective                    |
| **Success Metric** | Measurable criterion | Quantifiable indicator of goal achievement               |
| **Priority**     | `must` / `should` / `could` | MoSCoW priority classification                  |

### 2.2 User Personas (UP)

Named personas representing the system's user archetypes. Each entry MUST have:

| Field                    | Format    | Description                                              |
|--------------------------|-----------|----------------------------------------------------------|
| **ID**                   | `UP-NNN`  | Sequential numeric identifier (e.g., `UP-001`)          |
| **Name**                 | Free text | A descriptive persona name (e.g., "Operations Manager") |
| **Role**                 | Free text | The persona's role within the business domain            |
| **Goals**                | List      | What this persona aims to achieve with the system        |
| **Pain Points**          | List      | Current problems this persona experiences                |
| **Technical Proficiency**| Level     | Low / Medium / High — affects UX expectations            |

### 2.3 Feature Narratives (FN)

User stories or feature descriptions linking personas to system capabilities. Each entry MUST have:

| Field                   | Format      | Description                                              |
|-------------------------|-------------|----------------------------------------------------------|
| **ID**                  | `FN-NNN`    | Sequential numeric identifier (e.g., `FN-001`)          |
| **Persona Reference**   | `UP-NNN`    | Reference to the persona this feature serves             |
| **Narrative**           | User story  | "As a [persona], I want [capability] so that [benefit]"  |
| **Acceptance Criteria** | Numbered list | Specific, testable conditions that define "done"       |

### 2.4 Non-Functional Requirements (NFR)

Performance, security, scalability, availability, and other quality attributes. Each entry MUST have:

| Field                  | Format     | Description                                              |
|------------------------|------------|----------------------------------------------------------|
| **ID**                 | `NFR-NNN`  | Sequential numeric identifier (e.g., `NFR-001`)         |
| **Category**           | Enum       | Performance / Security / Scalability / Availability / Reliability / Maintainability / Other |
| **Specification**      | Free text  | Precise statement of the requirement                     |
| **Measurement Method** | Free text  | How compliance will be verified                          |

### 2.5 Integration Points (IP)

External systems, APIs, and data sources the system must interact with. Each entry MUST have:

| Field               | Format    | Description                                              |
|----------------------|-----------|----------------------------------------------------------|
| **ID**               | `IP-NNN`  | Sequential numeric identifier (e.g., `IP-001`)          |
| **System Name**      | Free text | Name of the external system                              |
| **Protocol**         | Free text | Communication protocol (REST, gRPC, AMQP, JDBC, etc.)   |
| **Data Format**      | Free text | Interchange format (JSON, XML, Protobuf, CSV, etc.)      |
| **Authentication**   | Free text | Auth mechanism (OAuth2, API Key, mTLS, none, etc.)       |
| **SLA**              | Free text | Expected availability, latency, throughput constraints    |

### 2.6 Deployment Constraints (DC)

Infrastructure, environment, and compliance requirements. Each entry MUST have:

| Field               | Format    | Description                                              |
|----------------------|-----------|----------------------------------------------------------|
| **ID**               | `DC-NNN`  | Sequential numeric identifier (e.g., `DC-001`)          |
| **Constraint Type**  | Free text | Infrastructure / Environment / Compliance / Regulatory   |
| **Specification**    | Free text | Precise statement of the constraint                      |
| **Rationale**        | Free text | Why this constraint exists and what it protects           |

---

## 3. Parsing and Normalization Steps

The Analyst mode MUST follow this exact sequence when processing a received HLD document. No step may be skipped or reordered.

### Step 1: Receive HLD Document

Accept the HLD document in any supported text-based format. If the format is not markdown, convert to markdown first. Record the receipt in the audit log with timestamp and source format.

### Step 2: Identify Section Boundaries

Scan the document for section boundaries using:
- Markdown headers (`#`, `##`, `###`)
- Structural markers (numbered sections, bold labels)
- Keyword matching against the 6 required section names

Map each identified section to one of the 6 required section types (BG, UP, FN, NFR, IP, DC).

### Step 3: Validate Presence of All 6 Required Sections

Verify that all 6 required sections are present and non-empty:
1. Business Goals (BG)
2. User Personas (UP)
3. Feature Narratives (FN)
4. Non-Functional Requirements (NFR)
5. Integration Points (IP)
6. Deployment Constraints (DC)

If any section is missing or empty → proceed to **Section 4: Missing Section Handling** (HALT).

### Step 4: Normalize Requirement IDs

For each requirement in each section:
- If the requirement already has an ID matching the expected prefix scheme, preserve it
- If the requirement lacks an ID, assign a sequential ID using the section prefix (e.g., `BG-001`, `BG-002`)
- Ensure IDs are unique within their section
- Assign a global cross-reference ID `[HLD-REQ-NNN]` to every requirement across all sections, numbered sequentially from 001

### Step 5: Extract Ubiquitous Language Terms

Scan the entire validated HLD for domain-specific terms:
- **Nouns**: Business entities, concepts, roles, artifacts
- **Verbs**: Business actions, processes, state transitions
- **Phrases**: Multi-word domain concepts

Extract terms **verbatim** — do not paraphrase or rename. Create initial glossary entries for each term with:
- Term as used in the HLD
- Source section(s) where the term appears
- Contextual definition derived from usage
- Related terms within the HLD

### Step 6: Cross-Reference Persona References

For every Feature Narrative (`FN-NNN`):
- Extract the persona reference (`UP-NNN`)
- Verify that the referenced persona exists in the User Personas section
- If a narrative references a persona that does not exist → flag as an ambiguity (see Section 5)

### Step 7: Produce Validated HLD Artifact

Generate a **Validated HLD** artifact with:
- All 6 sections normalized to the standard structure defined in Section 2
- All requirements assigned both section-local IDs and global `[HLD-REQ-NNN]` tags
- An appended ubiquitous language glossary seed
- A cross-reference validation report confirming all persona references resolve
- Metadata: original format, processing timestamp, total requirement count per section

---

## 4. Missing Section Handling — HALT Rule

If **any** of the 6 required sections is missing or empty, Roo **MUST halt all processing immediately**. No partial domain modeling is permitted.

Emit a structured clarification request in this exact format:

```
## HLD Validation Failure — Missing Sections

The following required HLD sections are missing or empty:

| # | Section | Expected Content |
|---|---------|-----------------|
| 1 | [section name] | [description of what is needed] |

**Action Required**: Please provide the missing sections before processing can continue.
**Blocked Domains**: All — no domain modeling may proceed until HLD is complete.
```

### Rules:

- List ALL missing sections in a single request — do not emit one request per missing section
- The `Expected Content` column must describe the structural requirements from Section 2 of this document
- Processing remains halted until the customer provides the missing sections
- Upon receiving the missing sections, restart from Step 1 (re-validate the entire HLD)

---

## 5. Ambiguity Handling — BLOCK Rule

If any section contains **ambiguous requirements**, Roo **MUST** block progress on the affected domain until the ambiguity is resolved. Ambiguity includes:

- **Contradictory statements**: Two requirements that cannot both be true
- **Undefined terms**: Domain terms used without definition or with inconsistent meanings
- **Vague acceptance criteria**: Criteria that cannot be deterministically tested
- **Missing boundary conditions**: Requirements that do not specify edge cases or limits

For each detected ambiguity, Roo MUST:

1. Generate **2 or more** candidate interpretations
2. **Rank** them by likelihood based on surrounding context
3. State **explicit assumptions** for each interpretation
4. **Block** progress on the affected domain until resolved

Emit a structured ambiguity report in this exact format:

```
## HLD Ambiguity Detected

**Requirement**: [ID and text]
**Affected Domain**: [domain name]

### Candidate Interpretations

| Rank | Interpretation | Assumptions | Impact |
|------|---------------|-------------|--------|
| 1 | [most likely] | [assumptions] | [scope impact] |
| 2 | [alternative] | [assumptions] | [scope impact] |

**Action Required**: Please confirm the correct interpretation or provide clarification.
**Blocked**: Domain "[name]" is blocked until this ambiguity is resolved.
```

### Rules:

- Multiple ambiguities may be reported in a single message, each with its own table
- Ambiguity resolution responses from the customer must be recorded in the audit log
- Once resolved, the chosen interpretation is incorporated into the Validated HLD and the domain is unblocked
- If a resolution introduces new ambiguities, those must also be reported before proceeding

---

## 6. Requirement Numbering Scheme

All requirements extracted from the HLD receive a **composite traceability tag** system:

### Section-Local IDs

Each requirement gets an ID scoped to its section using the section prefix:

| Section                  | Prefix   | Example      |
|--------------------------|----------|--------------|
| Business Goals           | `BG`     | `HLD-BG-001` |
| User Personas            | `UP`     | `HLD-UP-001` |
| Feature Narratives       | `FN`     | `HLD-FN-001` |
| Non-Functional Requirements | `NFR` | `HLD-NFR-001`|
| Integration Points       | `IP`     | `HLD-IP-001` |
| Deployment Constraints   | `DC`     | `HLD-DC-001` |

Format: `[HLD-{SECTION_PREFIX}-NNN]`

### Global Cross-Reference IDs

Every requirement also receives a global sequential ID for cross-document traceability:

Format: `[HLD-REQ-NNN]`

Where `NNN` is a zero-padded sequential number starting from `001`, assigned in document order across all sections.

### Traceability Guarantee

Every DDD artifact, test, and implementation artifact created in subsequent phases **MUST** reference at least one `[HLD-REQ-NNN]` tag. This creates an unbroken traceability chain from HLD requirements through domain model to test code to production code. See [02-ddd-transformation.md](02-ddd-transformation.md) Section 13 for the traceability tag mandate.
