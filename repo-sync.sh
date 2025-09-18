#!/bin/bash

# Your repos
REPO_A="git@github.com:your-user/repo-a.git"
REPO_B="git@github.com:your-user/repo-b.git"

# Working dirs
WORKDIR=~/repo-sync
mkdir -p $WORKDIR
cd $WORKDIR

# Clone/pull repos
if [ ! -d repo-a ]; then
  git clone --quiet --mirror $REPO_A repo-a
else
  cd repo-a && git fetch --tags --quiet && cd ..
fi

if [ ! -d repo-b ]; then
  git clone --quiet $REPO_B repo-b
else
  cd repo-b && git pull --quiet origin main && cd ..
fi

# Rebuild status.md
cd repo-b
echo "## Tags from Repo A" > status.md
for t in $(git --git-dir=../repo-a tag --sort=-creatordate); do
    commit=$(git --git-dir=../repo-a log -1 --pretty=format:"%h" $t)
    msg=$(git --git-dir=../repo-a log -1 --pretty=format:"%s" $t)
    date=$(git --git-dir=../repo-a log -1 --pretty=format:"%cd" --date=short $t)
    echo "- **$t** ($date) - $msg [$commit]" >> status.md
done

# Commit & push if changed
git add status.md
git commit -m "Update tag list from Repo A" || echo "No changes"
git push origin main
