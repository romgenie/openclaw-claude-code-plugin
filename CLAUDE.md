# OpenClaw Extension — Claude Code Plugin

This is a Claude Code plugin for developing and working with the OpenClaw platform.

## Project Layout

- `.claude-plugin/plugin.json` — Plugin manifest
- `skills/` — Slash commands for OpenClaw development workflows
- `hooks/` — Lifecycle hooks for code quality enforcement
- `.mcp.json` — MCP server configuration for OpenClaw tooling
- `settings.json` — Default Claude Code settings for OpenClaw development
- `lib/openclaw/` — OpenClaw monorepo (reference, read-only)

## OpenClaw Monorepo Conventions

- **Language**: TypeScript (ESM), strict typing, no `any`
- **Runtime**: Node 22+, pnpm for package management, Bun preferred for TS execution
- **Formatting/Linting**: Oxlint and Oxfmt (`pnpm check`, `pnpm format`)
- **Testing**: Vitest with V8 coverage (70% threshold), colocated `*.test.ts` files
- **Build**: `pnpm build`, type-check with `pnpm tsgo`
- **Plugin SDK**: Import only from `openclaw/plugin-sdk/<subpath>`, never from `src/**`
- **Naming**: "OpenClaw" for product/docs, `openclaw` for CLI/packages/config

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

## Configuration

- **`OPENCLAW_REPO_PATH`** — Path to the OpenClaw monorepo (default: `lib/openclaw`). Set this in your environment or in `.claude/settings.local.json` under `env` if the monorepo is cloned elsewhere.

## Verification Gates

- **Dev loop**: `pnpm check`
- **Landing**: `pnpm check` + `pnpm test` + `pnpm build` (if touching build surfaces)
- **Format**: `pnpm format` (oxfmt --check)
