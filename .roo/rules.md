# Roo Execution Policy

Before executing ANY command, you MUST read and strictly follow
the full execution policy defined in:

    .agents/ROO_EXECUTION_RULES.md

That file is the single source of truth for:
- which wrapper scripts are allowed
- which binaries and shell features are forbidden
- syntax, flags, path validation, and security rules for every wrapper

You MUST NOT execute any command that is not approved by that policy.
You MUST NOT bypass, ignore, or reinterpret any rule in that file.

If a command or operation you need is not covered by the existing
wrappers listed in that file, you must propose an extension to a
wrapper — never try to invoke a binary directly.
