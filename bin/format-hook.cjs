const { execFileSync } = require("child_process");
const fs = require("fs");
const pathModule = require("path");
const { path, found } = require("./detect-monorepo.cjs");

if (!found) {
  console.error("[openclaw] Monorepo not found — skipping format hook (standalone mode)");
  process.exit(0);
}

const file = process.env.CLAUDE_FILE_PATH
  ? pathModule.resolve(process.env.CLAUDE_FILE_PATH)
  : "";

if (file && (file.endsWith(".ts") || file.endsWith(".tsx"))) {
  const localBin = pathModule.join(path, "node_modules", ".bin", "oxfmt");
  const hasLocal = fs.existsSync(localBin) || fs.existsSync(localBin + ".cmd");

  try {
    if (hasLocal) {
      const bin = process.platform === "win32" ? localBin + ".cmd" : localBin;
      execFileSync(bin, ["--write", "--", file], {
        cwd: path,
        stdio: "ignore",
      });
    } else {
      const npx = process.platform === "win32" ? "npx.cmd" : "npx";
      execFileSync(npx, ["-y", "oxfmt", "--write", "--", file], {
        cwd: path,
        stdio: "ignore",
      });
    }
  } catch (e) {
    // Formatter failures should not block the hook
  }
}
