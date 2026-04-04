#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");

const pluginRoot = path.resolve(__dirname, "..");
const repoPath = path.resolve(pluginRoot, "lib/openclaw");
const dirs = ["src", "extensions", "docs"].map((d) => path.resolve(repoPath, d));

const child = spawn(
  "npx",
  ["-y", "@anthropic-ai/mcp-server-filesystem", ...dirs],
  { stdio: "inherit", shell: true }
);

child.on("close", (code) => process.exit(code || 0));
