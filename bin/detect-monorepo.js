const fs = require("fs");
const pathModule = require("path");

const path = process.env.OPENCLAW_REPO_PATH || "lib/openclaw";
const found = fs.existsSync(pathModule.join(path, "package.json"));

module.exports = { path, found };
