---
name: check
description: Run the OpenClaw verification gate (lint, format, typecheck)
---

# OpenClaw Check

Run the standard OpenClaw dev verification gate.

## Steps

1. Navigate to the OpenClaw monorepo root.
2. Run `pnpm check` — this runs Oxlint and Oxfmt together.
3. If failures occur, analyze the output and suggest fixes.
4. If formatting issues are found, suggest running `pnpm format:fix` to auto-fix.
5. Report results concisely — pass/fail with actionable items.

## Notes

- `pnpm check` is the standard dev loop gate.
- For landing on `main`, also run `pnpm test` and `pnpm build` (if touching build surfaces).
- Type-checking alone: `pnpm tsgo`.
- Format check alone: `pnpm format`.
