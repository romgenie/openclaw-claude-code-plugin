---
name: test-plugin
description: Run tests for an OpenClaw plugin or the full test suite
arguments:
  - name: target
    description: "Plugin name, file path, or test filter (e.g., 'anthropic', 'src/commands/onboard-search.test.ts')"
    required: false
---

# Test OpenClaw Plugin

Run tests for OpenClaw plugins using Vitest.

## Steps

1. If a target is specified, run scoped tests:
   ```
   pnpm test $ARGUMENTS.target
   ```
   Otherwise, run the full suite:
   ```
   pnpm test
   ```

2. Analyze failures — read the failing test file and the source it covers.

3. For memory-constrained environments, use:
   ```
   OPENCLAW_VITEST_MAX_WORKERS=1 pnpm test
   ```

4. Report results with pass/fail counts and actionable next steps.

## Notes

- Use `pnpm test <path-or-filter>` (not raw `pnpm vitest run`).
- Tests use Vitest with V8 coverage (70% threshold).
- Test files are colocated: `foo.ts` → `foo.test.ts`.
- Prefer model constants `sonnet-4.6` and `gpt-5.4` in test fixtures.
- For live tests with real API keys: `OPENCLAW_LIVE_TEST=1 pnpm test:live`.
