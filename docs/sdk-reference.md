# OpenClaw Plugin SDK — Quick Reference

This is a bundled subset of the OpenClaw Plugin SDK documentation, shipped with the plugin
so that skills work without requiring the full monorepo.

## Import Convention

Always use focused subpath imports — never import from the monolithic root or from `src/**`:

```typescript
import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";
```

## SDK Subpaths

| Subpath             | Primary Export                          | Purpose                          |
|---------------------|-----------------------------------------|----------------------------------|
| `plugin-entry`      | `definePluginEntry`                     | Standard plugin entry point      |
| `core`              | `defineChannelPluginEntry`, `createChatChannelPlugin` | Channel plugin entry     |
| `provider-entry`    | `defineSingleProviderPluginEntry`       | Single-provider plugin entry     |
| `config-schema`     | `OpenClawSchema`                        | Config schema builder            |
| `channel-core`      | Channel entry/setup utilities           | Channel lifecycle helpers        |
| `runtime-store`     | `createPluginRuntimeStore`              | Per-plugin runtime state store   |

## Plugin Structure

A valid OpenClaw plugin requires:

```
my-plugin/
├── openclaw.plugin.json   # Manifest: id, configSchema, capabilities
├── package.json           # Must have openclaw.extensions pointing to entry
├── index.ts               # Entry: default export from definePluginEntry
└── index.test.ts          # Colocated Vitest test
```

### Manifest (`openclaw.plugin.json`)

```json
{
  "id": "my-plugin",
  "configSchema": { ... },
  "capabilities": ["tool"]
}
```

### Entry Point (`index.ts`)

**Tool plugin:**
```typescript
import { Type } from "@sinclair/typebox";
import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";

export default definePluginEntry({
  id: "my-plugin",
  setup(api) {
    api.registerTool({
      name: "my-tool",
      description: "Does something useful",
      parameters: Type.Object({ input: Type.String() }),
      execute: async ({ input }) => { /* ... */ }
    });
  }
});
```

**Provider plugin:**
```typescript
import { defineSingleProviderPluginEntry } from "openclaw/plugin-sdk/provider-entry";

export default defineSingleProviderPluginEntry({
  id: "my-provider",
  // ...
});
```

**Channel plugin:**
```typescript
import { defineChannelPluginEntry } from "openclaw/plugin-sdk/core";

export default defineChannelPluginEntry({
  id: "my-channel",
  // ...
});
```

## Conventions

- **TypeScript (ESM)**, strict typing, no `any`
- **Node 22+**, pnpm for packages, Bun preferred for TS execution
- **Formatting/Linting**: Oxlint and Oxfmt (`pnpm check`, `pnpm format`)
- **Testing**: Vitest with V8 coverage (70% threshold), colocated `*.test.ts`
- **File size**: under ~700 LOC, split when it aids clarity
- **Dependencies**: plugin deps in extension `package.json`, not root; `workspace:*` only in devDependencies/peerDependencies
- **Naming**: "OpenClaw" in docs, `openclaw` in code/config
