---
name: review-extension
description: Review an OpenClaw extension for correctness, conventions, and pre-submission readiness
arguments:
  - name: extension_path
    description: "Path to the extension directory (e.g., 'lib/openclaw/extensions/my-plugin')"
    required: true
---

# Review OpenClaw Extension

Validate an OpenClaw extension against the project's standards and pre-submission checklist.

## Checklist

1. **Manifest** — `openclaw.plugin.json` exists with valid `id` and `configSchema`.

2. **Package** — `package.json` has `openclaw.extensions` pointing to entry file(s).

3. **Entry point** — Uses `definePluginEntry` or `defineChannelPluginEntry` (not raw exports).

4. **Import boundaries**:
   - All SDK imports use `openclaw/plugin-sdk/<subpath>` (never `src/**`)
   - Internal imports use local barrels (`api.ts`, `runtime-api.ts`)
   - No self-imports through `openclaw/plugin-sdk/<own-id>` in production code

5. **Dependencies**:
   - Plugin-specific deps in extension `package.json`, not root
   - No `workspace:*` in `dependencies` (only in devDependencies/peerDependencies)

6. **Naming**:
   - Plugin ID consistent across manifest, folder, and package name
   - Package name follows `@openclaw/<id>` or approved suffix form

7. **Types** — No `any`, no `@ts-nocheck`, no inline lint suppressions without justification.

8. **Tests** — Colocated `*.test.ts` files exist and pass.

9. **File size** — No file exceeds ~700 LOC.

10. **Tool schemas** — No `Type.Union` in tool input schemas, no raw `format` property names.

## Report

For each item, report pass/fail/warning with specific file locations and fix suggestions.
