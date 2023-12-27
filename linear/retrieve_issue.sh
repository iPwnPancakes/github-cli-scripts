#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PARENT_DIR="${SCRIPT_DIR}/.."

export $(cat $PARENT_DIR/.env | xargs)

if [ -z "$LINEAR_API_URL" ]; then
    echo "LINEAR_API_URL is not set"
    exit 1
fi

if [ -z "$LINEAR_API_KEY" ]; then
    echo "LINEAR_API_KEY is not set"
    exit 1
fi

gql_query_json=$(cat $SCRIPT_DIR/view_issue_query.json | sed "s/<ISSUE_ID>/$1/")

response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: $LINEAR_API_KEY" --data "$gql_query_json" $LINEAR_API_URL)

errors=$(echo $response | jq -r '.errors')

if [ "$errors" != "null" ]; then
    echo $response | jq -r '.errors[0].extensions.userPresentableMessage'
    exit 1
fi

echo $response | jq -r '.data.issue.title'
exit 0
