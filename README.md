# Github CLI Scripts

This repository is meant to contain various github CLI scripts that I thought were useful.

## General Notes on how to use scripts
To use these scripts, we leverage the `gh alias` command like so:

> Note: The `!` character is important and must be at the beginning of the second argument string.

```shell
gh alias set 'ALIAS_NAME' '!~/<repo_path>/script'
```

Which will allow you to run the scripts by using the alias that you set, for example:
```shell
gh ALIAS_NAME
```

You can also take advantage of positional arguments, but that's beyond the scope of this README. If you want more information, take a look at the official GitHub CLI docs or shoot me a message on twitter or something:

https://twitter.com/iPwnPancakes

# Scripts

## `/linear/create_pr_from_issue.sh`

Creates a Pull Request on GitHub in the format `[ISSUE_ID] ISSUE_TITLE`. This was made because I found it extremely tedious to have to type out the Linear title twice; Once in Linear and once when creating the PR. 

### Usage

```shell
gh alias set 'prc' '!<repo>/linear/create_pr_from_issue.sh'
```

> **NOTE: Must be in git repo with valid Linear issueID as branch name**

```shell
gh prc
```
