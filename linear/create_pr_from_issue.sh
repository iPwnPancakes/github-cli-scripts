#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

branch_name=$(git branch --show-current)

if [ -z "$branch_name" ]; then
    echo "Could not determine current branch"
    exit 1
fi

resolve_base_branch() {
    local default_branch

    default_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
    if [ -n "$default_branch" ]; then
        echo "$default_branch"
        return 0
    fi

    for candidate in main master; do
        if git show-ref --verify --quiet "refs/heads/$candidate"; then
            echo "$candidate"
            return 0
        fi

        if git show-ref --verify --quiet "refs/remotes/origin/$candidate"; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

if ! base_branch=$(resolve_base_branch); then
    echo "Could not determine base branch. Expected default branch to be main or master."
    exit 1
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
