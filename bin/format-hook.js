const { execFileSync } = require("child_process");
const { path, found } = require("./detect-monorepo");

if (!found) process.exit(0);

const file = process.env.CLAUDE_FILE_PATH || "";

if (file.endsWith(".ts") || file.endsWith(".tsx")) {
  const npx = process.platform === "win32" ? "npx.cmd" : "npx";
  try {
    execFileSync(npx, ["oxfmt", "--write", file], {
      cwd: path,
      stdio: "ignore",
    });
  } catch (e) {
    // Formatter failures should not block the hook
  }
}
