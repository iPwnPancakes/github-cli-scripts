#!/usr/bin/env bash

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: this script must be run from inside a git repository."
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Error: remote 'origin' is not configured for this repository."
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is not installed or not on PATH."
  exit 1
fi

default_tag="v$(date +%Y.%m)"
tag="${1:-}"

if [ -z "$tag" ]; then
  if [ -t 0 ]; then
    read -r -p "Tag to create [${default_tag}]: " tag
    tag="${tag:-$default_tag}"
  else
    tag="$default_tag"
  fi
fi

if [ -z "$tag" ]; then
  echo "Error: tag cannot be empty."
  exit 1
fi

if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  echo "Error: local tag '$tag' already exists."
  exit 1
fi

if git ls-remote --tags --refs origin "refs/tags/$tag" | grep -q .; then
  echo "Error: remote tag '$tag' already exists on origin."
  exit 1
fi

echo "Creating tag '$tag' on HEAD..."
git tag -a "$tag" -m "Release $tag"

echo "Pushing tag '$tag' to origin..."
git push origin "refs/tags/$tag"

echo "Creating GitHub release '$tag' with auto-generated notes..."
gh release create "$tag" --title "$tag" --generate-notes

echo "Done: created and released '$tag'."
