# OpenClaw Claude Code Plugin

Claude Code plugin for developing and working with the OpenClaw platform.

## Requirements

- **Claude Code** 2.1.0 or later
- **Node.js** 18+
- **pnpm** (for monorepo commands)

## Installation

```bash
claude plugin install ./
```

Or use the plugin directory flag for testing:

```bash
claude --plugin-dir /path/to/this/directory
```

## Configuration

Set `OPENCLAW_REPO_PATH` to point to the OpenClaw monorepo if it is not at `lib/openclaw`:

```bash
export OPENCLAW_REPO_PATH=/path/to/openclaw
```

## Components

| Component | Description |
|-----------|-------------|
| `/openclaw:build-plugin` | Scaffold, build, and validate an OpenClaw plugin |
| `/openclaw:check` | Run the verification gate (lint, format, typecheck) |
| `/openclaw:test-plugin` | Run scoped or full test suite |
| `/openclaw:explore-sdk` | Search the Plugin SDK surface |
| `/openclaw:review-extension` | Pre-submission extension review |
| **PostToolUse hook** | Auto-formats TS/JS files with oxfmt |
| **PreToolUse hook** | Blocks invalid SDK imports and unjustified `any` usage |
| **MCP server** | Filesystem access to plugin-sdk, extensions, and docs |

## Operating Modes

### Standalone (default)

Works out of the box. Skills use bundled `docs/sdk-reference.md`. Hooks and MCP server
gracefully disable themselves with warnings when the monorepo is absent.

### Contributor

When the monorepo is detected, the plugin unlocks:

- MCP filesystem server for browsing live SDK source and extensions
- oxfmt auto-formatting hook for TS/JS files
- Skills that search monorepo source and extension examples
