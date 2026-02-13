#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="$HOME/.config/github-cli-scripts"
REPO_URL="git@github.com:iPwnPancakes/github-cli-scripts.git"

mkdir -p "$HOME/.config"

if [ -d "$TARGET_DIR" ]; then
  if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "Target exists but is not a git repo: $TARGET_DIR"
    exit 1
  fi

  echo "Updating existing install in $TARGET_DIR"
  git -C "$TARGET_DIR" pull --ff-only

  if [ ! -f "$TARGET_DIR/.env" ] && [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
  fi

  echo "Updated $TARGET_DIR"
  exit 0
fi

cd "$HOME/.config"
git clone "$REPO_URL" github-cli-scripts

cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"

echo "Installed to $TARGET_DIR"
