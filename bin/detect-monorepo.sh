#!/usr/bin/env bash
# Detect whether the OpenClaw monorepo is available.
# Checks OPENCLAW_REPO_PATH env var first, then the default lib/openclaw location.
# Prints the monorepo path if found, exits 1 if not.

REPO_PATH="${OPENCLAW_REPO_PATH:-lib/openclaw}"

if [ -f "$REPO_PATH/package.json" ]; then
  echo "$REPO_PATH"
  exit 0
fi

exit 1
