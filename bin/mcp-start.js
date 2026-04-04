#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");

const repoPath = process.env.OPENCLAW_REPO_PATH || "lib/openclaw";
const dirs = ["src", "extensions", "docs"].map((d) => path.join(repoPath, d));

const missing = dirs.filter((d) => !fs.existsSync(d));
if (missing.length > 0) {
  console.error(
    `[openclaw plugin] Warning: missing directories: ${missing.join(", ")}`
  );
  console.error(
    `Set OPENCLAW_REPO_PATH to point to the OpenClaw monorepo root.`
  );
}

const existing = dirs.filter((d) => fs.existsSync(d));
if (existing.length === 0) {
  console.error("[openclaw plugin] No valid directories found. Exiting.");
  process.exit(1);
}

const child = spawn(
  "npx",
  ["-y", "@anthropic-ai/mcp-server-filesystem", ...existing],
  { stdio: "inherit", shell: true }
);

child.on("close", (code) => process.exit(code || 0));
