const fs = require("fs");

const path = process.env.OPENCLAW_REPO_PATH || "lib/openclaw";
const found = fs.existsSync(path + "/package.json");

module.exports = { path, found };
