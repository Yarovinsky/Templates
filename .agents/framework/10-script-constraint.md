# 10 — Approved Wrapper Command Constraint

## Inviolable Rule

Roo may ONLY execute the approved base wrapper commands: `dotnet.cmd`, `docker.cmd`, `git.cmd`, `curl.cmd`, `repo.cmd`. This applies to ALL operations including but not limited to: analysis, planning, code generation, test generation, validation, reporting, and delivery.

---

## Scope of Constraint

This rule applies to:

- Direct command execution via command line
- Script references in configuration files
- Script invocation from within other scripts
- Any tooling or build configuration that references scripts
- Documentation references to executable scripts
- Skill prompts, examples, and handoff guidance

---

## Prohibited Actions

The following are **FATAL ERRORS**:

- Executing any command not from approved list
- Using shell commands directly instead of through approved wrappers (per `ROO_EXECUTION_RULES.md`)
- Referencing wrapper entry points through repository paths such as `.agents/scripts/dotnet.cmd`, `.agents/scripts/git.cmd`, or similar instead of using the bare approved commands
- Creating ad-hoc scripts in project directories (`src/`, `tests/`, `docs/`, etc.)

---

## Violation Handling

Any attempt to violate this constraint MUST:

1. HALT execution immediately.
2. Emit a violation report:
   ```
    ## FATAL: Wrapper Command Violation
   
   **Timestamp**: [ISO-8601]
   **Attempted Action**: [what was attempted]
    **Offending Command/Path**: 
    **Required Command**: one of `dotnet.cmd`, `docker.cmd`, `git.cmd`, `curl.cmd`, `repo.cmd`
   **Phase**: [current phase]
   **Skill**: [current skill]
   
    **Resolution**: Use only the approved bare wrapper command
   ```
3. Log to audit log with severity `FATAL` and event type `DEVIATION`.
4. Do NOT proceed until the violation is corrected.

---

## Manifest File Requirement

All wrapper implementations MUST be documented in `.agents\\scripts\\manifest.json`:

- **Location**: `.agents\\scripts\\manifest.json`
- **Purpose**: Single source of truth for internal wrapper implementation inventory.
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
- **Validation**: Before relying on wrapper implementation details, maintainers SHOULD verify the wrapper exists in the manifest. Skills should still invoke only the bare wrapper commands.

---


## Cross-Reference

This constraint works in conjunction with:

- `.agents/ROO_EXECUTION_RULES.md` — Defines the approved wrapper commands and security invariants.
- `.agents/framework/04-skill-definitions.md` — Defines which skills may execute approved wrapper commands.
- `.agents/framework/03-tdd-execution-model.md` — Quality gate validation uses approved wrapper commands for test execution.
