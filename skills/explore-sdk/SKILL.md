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

1. Search `lib/openclaw/src/plugin-sdk/` for files matching the query.

2. Search `lib/openclaw/docs/plugins/sdk-overview.md` for the relevant subpath documentation.

3. If looking for a registration method, check:
   - `lib/openclaw/docs/plugins/building-plugins.md` for usage examples
   - `lib/openclaw/docs/plugins/architecture.md` for capability model context
   - `lib/openclaw/docs/plugins/sdk-entrypoints.md` for entry point patterns

4. If looking for an existing implementation, search `lib/openclaw/extensions/` for real-world usage.

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
