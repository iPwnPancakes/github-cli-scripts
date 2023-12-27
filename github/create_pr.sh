branch_name=$(git branch --show-current)
issue_title=$(gh lin-s $branch_name)
pr_title="[$branch_name] $issue_title"

gh pr create --title "$pr_title" --body "Closes $branch_name" --assignee "@me"

echo "Created PR with title: \"$pr_title\""