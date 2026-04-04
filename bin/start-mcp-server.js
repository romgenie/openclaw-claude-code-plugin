const { spawn } = require("child_process");
const pathModule = require("path");
const { path, found } = require("./detect-monorepo");

if (!found) {
  console.error(
    `[openclaw] Monorepo not found at ${path} — MCP server disabled (standalone mode)`
  );
  process.exit(0);
}

const npx = process.platform === "win32" ? "npx.cmd" : "npx";
const child = spawn(
  npx,
  [
    "-y",
    "@anthropic-ai/mcp-server-filesystem",
    pathModule.join(path, "src"),
    pathModule.join(path, "extensions"),
    pathModule.join(path, "docs"),
  ],
  { stdio: "inherit" }
);

child.on("error", (err) => {
  console.error(`[openclaw] Failed to start MCP server: ${err.message}`);
  process.exit(1);
});

child.on("close", (code) => process.exit(code || 0));
