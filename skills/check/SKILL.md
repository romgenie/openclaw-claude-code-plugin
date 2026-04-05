---
name: check
description: Run the OpenClaw verification gate (lint, format, typecheck)
---

# OpenClaw Check

Run the standard OpenClaw dev verification gate.

## Prerequisites

This skill requires the OpenClaw monorepo. Check for `lib/openclaw/package.json` or the `OPENCLAW_REPO_PATH` environment variable.

If the monorepo is not available, report that `/check` requires contributor mode and suggest the user clone the monorepo into `lib/openclaw/`.

## Steps

1. Detect the monorepo path: use `OPENCLAW_REPO_PATH` if set, otherwise `lib/openclaw`.
2. Verify the monorepo exists (check for `package.json` at that path).
3. Run `pnpm check` in the monorepo root — this runs Oxlint and Oxfmt together.
4. If failures occur, analyze the output and suggest fixes.
5. If formatting issues are found, suggest running `pnpm format:fix` to auto-fix.
6. Report results concisely — pass/fail with actionable items.

## Notes

- `pnpm check` is the standard dev loop gate.
- For landing on `main`, also run `pnpm test` and `pnpm build` (if touching build surfaces).
- Type-checking alone: `pnpm tsgo`.
- Format check alone: `pnpm format`.
