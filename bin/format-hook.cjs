const { execFileSync } = require("child_process");
const fs = require("fs");
const pathModule = require("path");
const { path: repoPath, found } = require("./detect-monorepo.cjs");

if (!found) {
  console.error(
    `[openclaw] Monorepo not found — formatting disabled. Set OPENCLAW_REPO_PATH or clone into lib/openclaw.`
  );
  process.exit(0);
}

const file = process.env.CLAUDE_FILE_PATH
  ? pathModule.resolve(process.env.CLAUDE_FILE_PATH)
  : "";

// Only format files inside the monorepo
const resolvedRepo = pathModule.resolve(repoPath) + pathModule.sep;
if (file && !file.startsWith(resolvedRepo)) {
  process.exit(0);
}

const exts = [".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs"];
if (file && exts.some((ext) => file.endsWith(ext))) {
  const localBinPath = pathModule.join(repoPath, "node_modules", ".bin", "oxfmt");
  const bin = process.platform === "win32" ? localBinPath + ".cmd" : localBinPath;

  try {
    if (fs.existsSync(bin)) {
      execFileSync(bin, ["--write", "--", file], {
        cwd: repoPath,
        stdio: "ignore",
      });
    } else {
      // Check if oxfmt is available via npx before attempting
      const npx = process.platform === "win32" ? "npx.cmd" : "npx";
      try {
        execFileSync(npx, ["-y", "oxfmt", "--version"], {
          cwd: repoPath,
          stdio: "ignore",
        });
      } catch (e) {
        console.error(
          `[openclaw] oxfmt not found. Run pnpm install in the monorepo to enable formatting.`
        );
        process.exit(0);
      }
      execFileSync(npx, ["-y", "oxfmt", "--write", "--", file], {
        cwd: repoPath,
        stdio: "ignore",
      });
    }
  } catch (e) {
    // Formatter failures should not block the hook
  }
}
