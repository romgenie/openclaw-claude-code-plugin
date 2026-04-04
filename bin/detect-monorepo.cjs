const fs = require("fs");
const pathModule = require("path");

const repoPath = process.env.OPENCLAW_REPO_PATH
  ? pathModule.resolve(process.env.OPENCLAW_REPO_PATH)
  : pathModule.resolve(__dirname, "../lib/openclaw");
const found = fs.existsSync(pathModule.join(repoPath, "package.json"));

module.exports = { path: repoPath, found };
