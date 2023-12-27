# Github CLI Scripts

This repository is meant to contain various github CLI scripts that I thought were useful.

## Current integrations:

### /linear

- `create_pr_from_issue.sh`: Meant to create a PR in the format `[ISSUE_ID] ISSUE_TITLE`. This was made because I found it extremely tedious to have to type out the Linear title twice; Once in Linear and once when creating the PR. **NOTE: Branch name must be the issue ID**

# Usage

To use these scripts, we leverage the `gh alias` command like so:

Note: The `!` character is important and must be at the beginning of the second argument string.
```shell
gh alias set 'prc' '!<repo>/linear/create_pr_from_issue.sh'
```

Which will allow you to run the scripts by using the alias that you set, for example:
```shell
gh prc # Must be in directory with git repo
```
