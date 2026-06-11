#!/bin/bash
# Script to push the iOS app to GitHub
# 1. Create a repo on GitHub first (https://github.com/new)
# 2. Then run this script with your repo URL:
#    ./PushToGitHub.sh https://github.com/YOUR_USERNAME/SiteAttendanceLogger-iOS.git

set -e

REPO_URL="${1}"

if [ -z "$REPO_URL" ]; then
    echo "Usage: ./PushToGitHub.sh <repo-url>"
    echo ""
    echo "Steps:"
    echo "  1. Go to https://github.com/new"
    echo "  2. Create a repo named 'SiteAttendanceLogger-iOS' (public or private)"
    echo "  3. Run: ./PushToGitHub.sh https://github.com/YOUR_USER/SiteAttendanceLogger-iOS.git"
    exit 1
fi

cd "$(dirname "$0")"

# Set remote and push
git remote add origin "$REPO_URL"
git push -u origin main

echo ""
echo "Done! Now go to:"
echo "  https://github.com/$(echo "$REPO_URL" | sed 's/.*github.com\/\(.*\)\.git/\1/')/actions"
echo ""
echo "Click the 'Build IPA' workflow, then 'Run workflow' to build your IPA."
