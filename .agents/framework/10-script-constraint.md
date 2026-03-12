# 10 — Script Location Constraint

## Inviolable Rule

Roo may ONLY execute the approved command wrappers: `dotnet.cmd`, `docker.cmd`, `git.cmd`, `curl.cmd`, `repo.cmd`. This applies to ALL operations including but not limited to: analysis, planning, code generation, test generation, validation, reporting, and delivery.

---

## Scope of Constraint

This rule applies to:

- Direct script execution via command line
- Script references in configuration files
- Script invocation from within other scripts
- Any tooling or build configuration that references scripts
- Documentation references to executable scripts

---

## Prohibited Actions

The following are **FATAL ERRORS**:

- Executing any script not from approved list
- Using shell commands directly instead of through approved wrappers (per `ROO_EXECUTION_RULES.md`)
- Creating ad-hoc scripts in project directories (`src/`, `tests/`, `docs/`, etc.)

---

## Violation Handling

Any attempt to violate this constraint MUST:

1. HALT execution immediately.
2. Emit a violation report:
   ```
   ## FATAL: Script Location Violation
   
   **Timestamp**: [ISO-8601]
   **Attempted Action**: [what was attempted]
   **Offending Path**: 
   **Required Path**: 
   **Phase**: [current phase]
   **Skill**: [current skill]
   
   **Resolution**: Use only approved wrapper
   ```
3. Log to audit log with severity `FATAL` and event type `DEVIATION`.
4. Do NOT proceed until the violation is corrected.

---

## Manifest File Requirement

All scripts MUST be documented in `.agents\\scripts\\manifest.json`:

- **Location**: `.agents\\scripts\\manifest.json`
- **Purpose**: Single source of truth for all available scripts.
- **Schema**:
  ```json
  {
    "scripts": [
      {
        "name": "string - human-readable name",
        "entryPoint": "string - relative path to .cmd entry point",
        "implementation": "string - relative path to .ps1 implementation",
        "purpose": "string - what the script does",
        "phaseAssociation": ["array of phase numbers or 'all'"],
        "inputContract": "string - description of expected inputs",
        "outputContract": "string - description of outputs"
      }
    ],
    "sharedModules": [
      {
        "name": "string - module name",
        "path": "string - relative path",
        "purpose": "string - what the module provides"
      }
    ]
  }
  ```
- **Maintenance**: When a new script is added, the manifest MUST be updated in the same change.
- **Validation**: Before executing any script, the orchestrator SHOULD verify it exists in the manifest.

---


## Cross-Reference

This constraint works in conjunction with:

- `.agents/ROO_EXECUTION_RULES.md` — Defines the approved wrapper scripts and security invariants.
- `.agents/framework/04-skill-definitions.md` — Defines which skills may execute scripts (primarily Validator).
- `.agents/framework/03-tdd-execution-model.md` — Quality gate validation uses scripts for test execution.
