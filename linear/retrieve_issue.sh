export $(cat ~/.config/gh-scripts/.env | xargs)

gql_query_json=$(cat ~/.config/gh-scripts/linear/view_issue_query.json | sed "s/<ISSUE_ID>/$1/")

response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: $LINEAR_API_KEY" --data "$gql_query_json" https://api.linear.app/graphql)
errors=$(echo $response | jq -r '.errors')

if [ "$errors" != "null" ]; then
    exit 1
fi

echo $response | jq -r '.data.issue.title'
exit 0

