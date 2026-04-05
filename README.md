# OpenClaw Claude Code Plugin

Claude Code plugin for developing and working with the OpenClaw platform.

## Requirements

- **Claude Code** 2.1.0 or later

## Installation

```bash
claude plugin install ./
```

Or use the plugin directory flag for testing:

```bash
claude --plugin-dir /path/to/this/directory
```

## Components

| Component | Description |
|-----------|-------------|
| `/openclaw:build-plugin` | Scaffold, build, and validate an OpenClaw plugin |
| `/openclaw:explore-sdk` | Search the Plugin SDK surface |
| **PreToolUse hook** | Blocks invalid SDK imports and unjustified `any` usage |
