#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

branch_name=$(git branch --show-current)

if [ -z "$branch_name" ]; then
    echo "Could not determine current branch"
    exit 1
fi

base_branch="master"
if ! git show-ref --verify --quiet "refs/heads/$base_branch"; then
    base_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
fi

if [ -z "$base_branch" ]; then
    base_branch="master"
fi

issue_title=$($SCRIPT_DIR/retrieve_issue.sh $branch_name)
issue_title_exit_code=$?

if [ $issue_title_exit_code -eq 1 ]; then
    echo $issue_title
    exit 1
fi

if [ -z "$issue_title" ]; then
    echo "No Linear issue found for branch $branch_name"
    exit 1
fi

pr_title="[$branch_name] $issue_title"

if [ "$(git rev-list --count "$base_branch..$branch_name")" -eq 0 ]; then
    echo "No commits ahead of $base_branch; creating an empty commit so GitHub can open a PR"
    git commit --allow-empty -m "chore: initialize PR branch $branch_name"
fi

git push -u origin "$branch_name"
gh pr create --base "$base_branch" --head "$branch_name" --title "$pr_title" --body "Closes $branch_name" --assignee "@me"

echo "Created PR with title: \"$pr_title\""
