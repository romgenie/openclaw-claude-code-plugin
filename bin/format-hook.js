const { execSync } = require("child_process");
const { path, found } = require("./detect-monorepo");

if (!found) process.exit(0);

const file = process.env.CLAUDE_FILE_PATH || "";

if (file.endsWith(".ts") || file.endsWith(".tsx")) {
  execSync("npx oxfmt --write " + JSON.stringify(file), {
    cwd: path,
    stdio: "ignore",
  });
}
