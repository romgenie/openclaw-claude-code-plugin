---
name: explore-sdk
description: Explore the OpenClaw Plugin SDK surface — find subpaths, types, and registration APIs
arguments:
  - name: query
    description: "What to search for (e.g., 'registerTool', 'channel-core', 'provider auth')"
    required: true
---

# Explore OpenClaw Plugin SDK

The monorepo path is configurable via `OPENCLAW_REPO_PATH` (default: `lib/openclaw`).

Search the OpenClaw Plugin SDK to find the right imports, types, and registration methods.

## Steps

1. Search `$OPENCLAW_REPO_PATH/src/plugin-sdk/` for files matching the query.

2. Search `$OPENCLAW_REPO_PATH/docs/plugins/sdk-overview.md` for the relevant subpath documentation.

3. If looking for a registration method, check:
   - `$OPENCLAW_REPO_PATH/docs/plugins/building-plugins.md` for usage examples
   - `$OPENCLAW_REPO_PATH/docs/plugins/architecture.md` for capability model context
   - `$OPENCLAW_REPO_PATH/docs/plugins/sdk-entrypoints.md` for entry point patterns

4. If looking for an existing implementation, search `$OPENCLAW_REPO_PATH/extensions/` for real-world usage.

5. Report the correct import path, type signature, and a usage example.

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
