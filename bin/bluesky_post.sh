#!/bin/bash

# Usage: echo "Hello Bluesky!" | ./post_to_bsky.sh HANDLE APP_PASSWORD

# Check for required arguments
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 HANDLE APP_PASSWORD"
  echo "Example: echo \"Hello\" | $0 you.bsky.social abcd-efgh-ijkl"
  exit 1
fi

HANDLE="$1"
APP_PASSWORD="$2"

# Read post content from STDIN
STATUS=$(cat)

# Check if STATUS is not empty
if [[ -z "$STATUS" ]]; then
  echo "Error: No content provided via STDIN."
  exit 1
fi

# Step 1: Authenticate and get session token
SESSION_JSON=$(curl -sS -X POST https://bsky.social/xrpc/com.atproto.server.createSession \
  -H "Content-Type: application/json" \
  -d "{\"identifier\":\"$HANDLE\",\"password\":\"$APP_PASSWORD\"}")

DID=$(echo "$SESSION_JSON" | jq -r '.did')
ACCESS_JWT=$(echo "$SESSION_JSON" | jq -r '.accessJwt')

if [[ "$DID" == "null" || "$ACCESS_JWT" == "null" ]]; then
  echo "Authentication failed. Check handle or app password."
  echo "$SESSION_JSON"
  exit 1
fi

# Step 2: Get ISO 8601 datetime
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Step 3: Create post JSON and send it
POST_BODY=$(jq -n \
  --arg text "$STATUS" \
  --arg time "$NOW" \
  --arg did "$DID" \
  '{
    "$type": "app.bsky.feed.post",
    "text": $text,
    "createdAt": $time
  }')

curl -sS -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -d "$(jq -n \
    --arg repo "$DID" \
    --arg collection "app.bsky.feed.post" \
    --argjson record "$POST_BODY" \
    '{
      "repo": $repo,
      "collection": $collection,
      "record": $record
    }')"
