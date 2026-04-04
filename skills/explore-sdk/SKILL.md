---
name: explore-sdk
description: Explore the OpenClaw Plugin SDK surface — find subpaths, types, and registration APIs
arguments:
  - name: query
    description: "What to search for (e.g., 'registerTool', 'channel-core', 'provider auth')"
    required: true
---

# Explore OpenClaw Plugin SDK

Search the OpenClaw Plugin SDK to find the right imports, types, and registration methods.

## Steps

1. **Always** — Search the bundled `docs/sdk-reference.md` for information matching the query. This covers subpaths, types, entry points, and conventions.

2. **If the monorepo is available** (check for `lib/openclaw/package.json` or `OPENCLAW_REPO_PATH`):
   - Search `<monorepo>/src/plugin-sdk/` for source files matching the query
   - Search `<monorepo>/docs/plugins/sdk-overview.md` for detailed subpath documentation
   - If looking for a registration method, check:
     - `<monorepo>/docs/plugins/building-plugins.md` for usage examples
     - `<monorepo>/docs/plugins/architecture.md` for capability model context
     - `<monorepo>/docs/plugins/sdk-entrypoints.md` for entry point patterns
   - If looking for an existing implementation, search `<monorepo>/extensions/` for real-world usage

3. **If the monorepo is not available** — Use only the bundled reference. Note in the response that richer results are available in contributor mode with the full monorepo.

4. Report the correct import path, type signature, and a usage example.

## Key SDK Subpaths

- `plugin-entry` — `definePluginEntry`
- `core` — `defineChannelPluginEntry`, `createChatChannelPlugin`
- `provider-entry` — `defineSingleProviderPluginEntry`
- `config-schema` — `OpenClawSchema`
- `channel-core` — Channel entry/setup
- `runtime-store` — `createPluginRuntimeStore`

## Import Convention

Always use focused subpath imports:
```typescript
import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";
```
Never import from the monolithic root or from `src/**`.
