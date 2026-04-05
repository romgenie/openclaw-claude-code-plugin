# OpenClaw Extension — Claude Code Plugin

This is a Claude Code plugin for developing and working with the OpenClaw platform.

## Project Layout

- `.claude-plugin/plugin.json` — Plugin manifest
- `skills/` — Slash commands for OpenClaw development workflows
- `hooks/` — Lifecycle hooks for code quality enforcement
- `docs/` — Bundled SDK reference (ships with plugin, no monorepo required)
- `.mcp.json` — MCP server configuration (activates only when monorepo is present)
- `settings.json` — Default Claude Code settings for OpenClaw development
- `bin/` — Helper scripts (monorepo detection, etc.)

## Operating Modes

This plugin works in two modes:

### Standalone Mode (default)

The plugin works out of the box without the OpenClaw monorepo. Skills use the bundled
`docs/sdk-reference.md` for SDK types, imports, and examples. The MCP filesystem server
and oxfmt formatting hook are automatically disabled.

### Contributor Mode

When the OpenClaw monorepo is present, the plugin unlocks richer features:

- **MCP filesystem server** for browsing live SDK source, extensions, and docs
- **oxfmt hook** for auto-formatting TypeScript files on save
- **Skills** search monorepo source, docs, and 100+ extension examples

The monorepo is detected via `lib/openclaw/package.json` (default) or a custom path
set in the `OPENCLAW_REPO_PATH` environment variable.

To enter contributor mode, clone the monorepo:

```bash
git clone <openclaw-repo-url> lib/openclaw
```

Or set the env var to an existing checkout:

```bash
export OPENCLAW_REPO_PATH=/path/to/openclaw
```

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

## Verification Gates

- **Dev loop**: `pnpm check`
- **Landing**: `pnpm check` + `pnpm test` + `pnpm build` (if touching build surfaces)
- **Format**: `pnpm format` (oxfmt --check)
