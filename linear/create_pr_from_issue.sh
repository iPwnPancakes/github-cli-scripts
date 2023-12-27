#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

branch_name=$(git branch --show-current)

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
gh pr create --title "$pr_title" --body "Closes $branch_name" --assignee "@me"

echo "Created PR with title: \"$pr_title\""