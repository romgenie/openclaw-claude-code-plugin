---
name: build-plugin
description: Scaffold, build, and validate an OpenClaw plugin
arguments:
  - name: plugin_name
    description: The plugin ID (e.g., "my-tool", "acme-provider")
    required: true
  - name: plugin_type
    description: "Plugin type: tool, provider, or channel"
    required: false
    default: "tool"
---

# Build OpenClaw Plugin

Scaffold or validate an OpenClaw plugin named `$ARGUMENTS.plugin_name`.

## Steps

1. **Check existing structure** — Look for `openclaw.plugin.json`, `package.json` with `openclaw.extensions`, and the entry point (`index.ts`).

2. **Scaffold if missing** — Create the standard plugin structure:
   - `openclaw.plugin.json` with `id`, `configSchema`, and capability declarations
   - `package.json` with `openclaw` field pointing to `./index.ts`
   - `index.ts` using `definePluginEntry` from `openclaw/plugin-sdk/plugin-entry`
   - For providers: use `api.registerProvider()`
   - For tools: use `api.registerTool()` with `@sinclair/typebox` parameters
   - For channels: use `defineChannelPluginEntry` from `openclaw/plugin-sdk/channel-core`

3. **Validate** — Ensure:
   - All imports use `openclaw/plugin-sdk/<subpath>` (never `src/**`)
   - `configSchema` is valid JSON Schema
   - Plugin ID matches across manifest, folder name, and entry point
   - No `workspace:*` in `dependencies`
   - Entry point exports a default from `definePluginEntry` or `defineChannelPluginEntry`

4. **Test setup** — Create a colocated `index.test.ts` using Vitest.

5. **Report** — Show the generated/validated structure and next steps.

## Reference

The monorepo path is configurable via `OPENCLAW_REPO_PATH` (default: `lib/openclaw`).

See `$OPENCLAW_REPO_PATH/docs/plugins/building-plugins.md` for the full guide.
See `$OPENCLAW_REPO_PATH/extensions/` for 100+ examples of existing plugins.
