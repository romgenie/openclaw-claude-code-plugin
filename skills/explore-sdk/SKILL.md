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

1. Search the bundled `docs/sdk-reference.md` for information matching the query. This covers subpaths, types, entry points, and conventions.

2. Report the correct import path, type signature, and a usage example.

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
