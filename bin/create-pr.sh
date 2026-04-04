#!/bin/bash
# Usage: ./bin/create-pr.sh <branch> <title> <issue_num> <body>
set -e
BRANCH="$1"
TITLE="$2"
ISSUE="$3"
BODY="$4"

git checkout -b "$BRANCH" master
git add -A
git commit -m "$TITLE

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
git push -u origin "$BRANCH"
gh pr create --title "$TITLE" --body "$BODY

Closes #$ISSUE

🤖 Generated with [Claude Code](https://claude.com/claude-code)"
git checkout master
