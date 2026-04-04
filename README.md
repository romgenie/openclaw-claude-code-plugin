# OpenClaw Claude Code Plugin

Claude Code plugin for developing and working with the OpenClaw platform.

## Requirements

- **Claude Code** 2.1.0 or later (tested on 2.1.91)
- **Node.js** 18+
- **pnpm** (for monorepo commands)

## Installation

```bash
claude /plugin install ./
```

Or use the plugin directory flag for testing:

```bash
claude --plugin-dir /path/to/this/directory
```

## What's Included

| Component | Description |
|-----------|-------------|
| `/openclaw:build-plugin` | Scaffold, build, and validate an OpenClaw plugin |
| `/openclaw:check` | Run the verification gate (lint, format, typecheck) |
| `/openclaw:test-plugin` | Run scoped or full test suite |
| `/openclaw:explore-sdk` | Search the Plugin SDK surface |
| `/openclaw:review-extension` | Pre-submission extension review |
| **PostToolUse hook** | Auto-formats .ts/.tsx files with oxfmt |
| **PreToolUse hook** | Blocks invalid SDK imports |
| **MCP server** | Filesystem access to src/, extensions/, docs/ |

## Configuration

Set `OPENCLAW_REPO_PATH` to point to the OpenClaw monorepo if it's not at `lib/openclaw`.
