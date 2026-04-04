const { spawn } = require("child_process");
const pathModule = require("path");
const { path, found } = require("./detect-monorepo.cjs");

if (!found) {
  console.error(
    `[openclaw] Monorepo not found at ${pathModule.resolve(path)} — MCP server disabled (standalone mode)`
  );
  process.exit(0);
}

const fs = require("fs");
const dirs = ["src", "extensions", "docs"]
  .map((d) => pathModule.join(path, d))
  .filter((d) => fs.existsSync(d));

if (dirs.length === 0) {
  console.error(
    `[openclaw] Monorepo at ${pathModule.resolve(path)} has no src/extensions/docs — MCP server disabled`
  );
  process.exit(0);
}

const npx = process.platform === "win32" ? "npx.cmd" : "npx";
const child = spawn(
  npx,
  ["-y", "--quiet", "@anthropic-ai/mcp-server-filesystem", ...dirs],
  { stdio: "inherit" }
);

child.on("error", (err) => {
  console.error(`[openclaw] Failed to start MCP server: ${err.message}`);
  process.exit(1);
});

child.on("close", (code) => {
  if (code !== 0) console.error(`[openclaw] MCP server exited with code ${code}`);
  process.exit(code || 0);
});
