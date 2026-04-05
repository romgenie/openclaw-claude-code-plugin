# OpenClaw Extension — Claude Code Plugin

This is a Claude Code plugin for developing and working with the OpenClaw platform.

## Project Layout

- `.claude-plugin/plugin.json` — Plugin manifest
- `skills/` — Slash commands for OpenClaw development workflows
- `hooks/` — Lifecycle hooks for code quality enforcement
- `docs/` — Bundled SDK reference (ships with plugin)
- `settings.json` — Default Claude Code settings for OpenClaw development

## Plugin Development Rules

- Extensions must cross into core only through `openclaw/plugin-sdk/*`
- Use focused subpath imports, never monolithic root imports
- Keep plugin deps in extension `package.json`, not root
- Use `workspace:*` only in devDependencies/peerDependencies
- Internal imports via local barrels (`api.ts`, `runtime-api.ts`)
- Tests colocated with source (`*.test.ts`)
- Files under ~700 LOC, prefer splitting when it aids clarity

## Commit Style

- Concise, action-oriented: `CLI: add verbose flag to send`
- Group related changes, no unrelated refactors bundled
- Use `scripts/committer "<msg>" <file...>` when in the monorepo
