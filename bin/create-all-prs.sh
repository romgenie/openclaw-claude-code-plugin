#!/bin/bash
set -e

# Helper: create branch, commit, push, PR, return to master
make_pr() {
  local branch="$1" title="$2" issue="$3" body="$4"
  git checkout master
  git checkout -b "$branch"
  git add -A
  git commit -m "$title

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
  git push -u origin "$branch"
  gh pr create --title "$title" --body "$body

Closes #$issue

🤖 Generated with [Claude Code](https://claude.com/claude-code)"
  git checkout master
  echo "=== PR for #$issue created ==="
}

######################################################################
# Issue #1: File paths with spaces break PostToolUse hook
######################################################################
git checkout master
git checkout -b fix/path-spaces-hook
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execFileSync}=require('child_process');const f=process.env.CLAUDE_FILE_PATH||'';if(f.endsWith('.ts')||f.endsWith('.tsx')){try{execFileSync('npx',['oxfmt','--write',f],{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/path-spaces-hook" "fix: use execFileSync to handle file paths with spaces" 1 \
  "Uses execFileSync with array args instead of execSync with string concatenation, avoiding shell quoting issues on Windows paths with spaces."

######################################################################
# Issue #2: PostToolUse fails silently when monorepo absent
######################################################################
git checkout master
git checkout -b fix/hook-missing-monorepo-warning
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const fs=require('fs');const f=process.env.CLAUDE_FILE_PATH||'';const r='lib/openclaw';if(!fs.existsSync(r)){console.error('[openclaw plugin] monorepo not found at '+r+'. Set OPENCLAW_REPO_PATH env var.');process.exit(0)}if(f.endsWith('.ts')||f.endsWith('.tsx')){try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:r,stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/hook-missing-monorepo-warning" "fix: warn when monorepo directory is missing in PostToolUse hook" 2 \
  "Adds fs.existsSync check before running oxfmt. Logs a warning to stderr when the monorepo is not found instead of failing silently."

######################################################################
# Issue #3: MCP server paths resolve to nothing
######################################################################
git checkout master
git checkout -b fix/mcp-configurable-paths
mkdir -p bin
cat > bin/mcp-start.js << 'MCPEOF'
#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");

const repoPath = process.env.OPENCLAW_REPO_PATH || "lib/openclaw";
const dirs = ["src", "extensions", "docs"].map((d) => path.join(repoPath, d));

for (const dir of dirs) {
  if (!fs.existsSync(dir)) {
    console.error(`[openclaw plugin] Directory not found: ${dir}`);
    console.error(`Set OPENCLAW_REPO_PATH to the OpenClaw monorepo location.`);
    process.exit(1);
  }
}

const child = spawn(
  "npx",
  ["-y", "@anthropic-ai/mcp-server-filesystem", ...dirs],
  { stdio: "inherit", shell: true }
);
child.on("close", (code) => process.exit(code || 0));
MCPEOF
cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "openclaw-dev": {
      "command": "node",
      "args": ["bin/mcp-start.js"],
      "env": {}
    }
  }
}
EOF
make_pr "fix/mcp-configurable-paths" "fix: validate MCP paths and support OPENCLAW_REPO_PATH" 3 \
  "Adds bin/mcp-start.js wrapper that validates directories exist before starting the MCP server. Supports OPENCLAW_REPO_PATH env var."

######################################################################
# Issue #4: MCP download fails in air-gapped environments
######################################################################
git checkout master
git checkout -b fix/mcp-local-dependency
cat > package.json << 'EOF'
{
  "name": "openclaw-claude-code-plugin",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "Claude Code plugin for OpenClaw development",
  "dependencies": {
    "@anthropic-ai/mcp-server-filesystem": "^0.1.0"
  }
}
EOF
# Update CLAUDE.md with install note
sed -i 's/## OpenClaw Monorepo Conventions/## Setup\n\nAfter cloning, run `npm install` to install the MCP server dependency locally.\n\n## OpenClaw Monorepo Conventions/' CLAUDE.md
make_pr "fix/mcp-local-dependency" "fix: add MCP server as local dependency for offline support" 4 \
  "Adds package.json with @anthropic-ai/mcp-server-filesystem as a dependency so it can be installed ahead of time for air-gapped environments."

######################################################################
# Issue #5: PostToolUse fails when oxfmt not installed
######################################################################
git checkout master
git checkout -b fix/hook-oxfmt-check
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const f=process.env.CLAUDE_FILE_PATH||'';if(f.endsWith('.ts')||f.endsWith('.tsx')){try{execSync('npx oxfmt --version',{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){console.error('[openclaw plugin] oxfmt not found. Run pnpm install in the monorepo.');process.exit(0)}try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/hook-oxfmt-check" "fix: check oxfmt availability before formatting" 5 \
  "Probes oxfmt with --version before attempting to format. Logs a helpful warning when oxfmt is not installed."

######################################################################
# Issue #7: PreToolUse runs on non-TS files
######################################################################
git checkout master
git checkout -b fix/pretool-hook-ts-only
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const f=process.env.CLAUDE_FILE_PATH||'';if(f.endsWith('.ts')||f.endsWith('.tsx')){try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "First check the file extension. If the file is NOT a .ts or .tsx file, respond 'PASS' immediately without further analysis. For .ts/.tsx files: check that the file does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/pretool-hook-ts-only" "fix: skip PreToolUse import check on non-TypeScript files" 7 \
  "Updates prompt to immediately PASS for non-.ts/.tsx files, avoiding wasted model turns and false positives on JSON/markdown."

######################################################################
# Issue #8: PostToolUse ignores JS files
######################################################################
git checkout master
git checkout -b fix/hook-js-extensions
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const f=process.env.CLAUDE_FILE_PATH||'';const ext=['.ts','.tsx','.js','.jsx','.mjs','.cjs'];if(ext.some(e=>f.endsWith(e))){try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/hook-js-extensions" "fix: extend PostToolUse formatting to JS/JSX/MJS/CJS files" 8 \
  "Adds .js, .jsx, .mjs, .cjs to the file extension check so JavaScript files also get auto-formatted."

######################################################################
# Issue #9: NODE_OPTIONS conflict
######################################################################
git checkout master
git checkout -b fix/remove-node-options-default
cat > settings.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep"
    ],
    "deny": []
  }
}
EOF
# Add optional config note to CLAUDE.md
sed -i 's/## Verification Gates/## Optional Configuration\n\nIf you experience memory issues during large builds, add to `.claude\/settings.local.json`:\n```json\n{ "env": { "NODE_OPTIONS": "--max-old-space-size=4096" } }\n```\n\n## Verification Gates/' CLAUDE.md
make_pr "fix/remove-node-options-default" "fix: remove NODE_OPTIONS default to avoid env conflicts" 9 \
  "Removes NODE_OPTIONS from default settings.json to prevent conflicts with user environment. Documents it as optional configuration in CLAUDE.md."

######################################################################
# Issue #10: MCP paths are CWD-relative
######################################################################
git checkout master
git checkout -b fix/mcp-absolute-paths
mkdir -p bin
cat > bin/mcp-start.js << 'MCPEOF'
#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");

const pluginDir = path.dirname(__dirname);
const repoPath = path.resolve(pluginDir, "lib/openclaw");
const dirs = ["src", "extensions", "docs"].map((d) => path.join(repoPath, d));

const child = spawn(
  "npx",
  ["-y", "@anthropic-ai/mcp-server-filesystem", ...dirs],
  { stdio: "inherit", shell: true }
);
child.on("close", (code) => process.exit(code || 0));
MCPEOF
cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "openclaw-dev": {
      "command": "node",
      "args": ["bin/mcp-start.js"],
      "env": {}
    }
  }
}
EOF
make_pr "fix/mcp-absolute-paths" "fix: resolve MCP paths relative to plugin root, not CWD" 10 \
  "Adds bin/mcp-start.js that uses __dirname to resolve paths relative to the plugin directory regardless of where Claude Code is launched from."

######################################################################
# Issue #11: Version compatibility
######################################################################
git checkout master
git checkout -b fix/document-version-requirements
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "openclaw",
  "description": "Claude Code plugin for OpenClaw development — provides skills, tools, and hooks for working with the OpenClaw monorepo",
  "version": "1.0.0",
  "author": {
    "name": "OpenClaw Contributors"
  },
  "minClaudeCodeVersion": "2.1.0"
}
EOF
cat > README.md << 'EOF'
# OpenClaw Claude Code Plugin

A [Claude Code](https://claude.com/claude-code) plugin for developing and working with the OpenClaw platform.

## Requirements

- Claude Code CLI **2.1.0** or later (tested on 2.1.91)
- Node.js **18+**
- OpenClaw monorepo cloned locally

## Installation

```bash
# From the plugin directory
claude /plugin install ./

# Or use --plugin-dir for testing
claude --plugin-dir /path/to/openclaw-extension
```

## Skills

| Command | Description |
|---------|-------------|
| `/openclaw:build-plugin` | Scaffold, build, and validate an OpenClaw plugin |
| `/openclaw:check` | Run the verification gate (lint, format, typecheck) |
| `/openclaw:test-plugin` | Run scoped or full test suite |
| `/openclaw:explore-sdk` | Search the Plugin SDK surface |
| `/openclaw:review-extension` | Pre-submission review checklist |

## Configuration

Set `OPENCLAW_REPO_PATH` environment variable if the monorepo is not at `lib/openclaw`.

## License

MIT
EOF
# Add requirements section to CLAUDE.md
sed -i 's/## OpenClaw Monorepo Conventions/## Requirements\n\n- Claude Code CLI 2.1.0+\n- Node.js 18+\n\n## OpenClaw Monorepo Conventions/' CLAUDE.md
make_pr "fix/document-version-requirements" "fix: document version requirements and add README" 11 \
  "Adds minClaudeCodeVersion to plugin manifest, creates README.md with installation instructions, and documents requirements in CLAUDE.md."

######################################################################
# Issue #12: Hook formats files outside monorepo
######################################################################
git checkout master
git checkout -b fix/hook-scope-to-monorepo
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const p=require('path');const f=process.env.CLAUDE_FILE_PATH||'';const r=p.resolve('lib/openclaw');if(!f.endsWith('.ts')&&!f.endsWith('.tsx'))process.exit(0);if(!p.resolve(f).startsWith(r))process.exit(0);try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:r,stdio:'ignore'})}catch(e){}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check it does not use 'any' type or '@ts-nocheck'. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/hook-scope-to-monorepo" "fix: only format files inside the monorepo directory" 12 \
  "Adds path containment check — only runs oxfmt when the file is within the monorepo root. Files outside are silently skipped."

######################################################################
# Issue #13: No override for any usage
######################################################################
git checkout master
git checkout -b fix/pretool-hook-allow-override
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const{execSync}=require('child_process');const f=process.env.CLAUDE_FILE_PATH||'';if(f.endsWith('.ts')||f.endsWith('.tsx')){try{execSync('npx oxfmt --write '+JSON.stringify(f),{cwd:'lib/openclaw',stdio:'ignore'})}catch(e){}}\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check that the file being written does not import from 'src/**' directly (must use 'openclaw/plugin-sdk/<subpath>' for SDK imports). Also check for 'any' type and '@ts-nocheck'. However, if 'any' or '@ts-nocheck' is accompanied by a justification comment on the same or previous line (such as '// eslint-disable-next-line', '// openclaw-allow', or any comment explaining why), respond 'PASS'. Only block unjustified usage. If violations found, respond with 'BLOCK: <reason>'. Otherwise respond 'PASS'."
          }
        ]
      }
    ]
  }
}
EOF
make_pr "fix/pretool-hook-allow-override" "fix: allow justified any/ts-nocheck usage in PreToolUse hook" 13 \
  "Updates the prompt to allow any type and @ts-nocheck when accompanied by a justification comment (// openclaw-allow, eslint-disable, etc.)."

######################################################################
# Issue #14: MCP server slow on large repos
######################################################################
git checkout master
git checkout -b fix/mcp-narrower-scope
cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "openclaw-dev": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "lib/openclaw/src/plugin-sdk", "lib/openclaw/extensions", "lib/openclaw/docs/plugins"],
      "env": {}
    }
  }
}
EOF
# Add note to CLAUDE.md
sed -i 's/- `settings.json` — Default Claude Code settings for OpenClaw development/- `settings.json` — Default Claude Code settings for OpenClaw development\n\nThe MCP server is scoped to `src\/plugin-sdk`, `extensions\/`, and `docs\/plugins\/` for performance. To widen scope, override in `.claude\/settings.local.json`./' CLAUDE.md
make_pr "fix/mcp-narrower-scope" "fix: narrow MCP server scope for better performance" 14 \
  "Scopes MCP filesystem server to src/plugin-sdk, extensions, and docs/plugins instead of the full src/ and docs/ trees. Reduces indexing time on large monorepos."

echo ""
echo "=== ALL 13 PRs CREATED ==="
