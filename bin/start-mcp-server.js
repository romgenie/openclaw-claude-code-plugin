const { spawn } = require("child_process");
const { path, found } = require("./detect-monorepo");

if (!found) {
  console.error(
    "[openclaw] Monorepo not found at " +
      path +
      " — MCP server disabled (standalone mode)"
  );
  process.exit(0);
}

const npx = process.platform === "win32" ? "npx.cmd" : "npx";
const child = spawn(
  npx,
  [
    "-y",
    "@anthropic-ai/mcp-server-filesystem",
    path + "/src",
    path + "/extensions",
    path + "/docs",
  ],
  { stdio: "inherit" }
);

child.on("close", (code) => process.exit(code || 0));
