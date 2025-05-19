#!/bin/bash

# Usage: ./mastodon_post.sh INSTANCE_URL ACCESS_TOKEN
# Example: echo "A post" | ./post_to_mastodon.sh $MY_MASTODON_URL $MY_ACCESS_TOKEN

# Use environment variables; DO NOT pass the access token directly on the
# command line for security reasons.

# Check for required arguments
if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 INSTANCE_URL ACCESS_TOKEN"
    exit 1
fi

INSTANCE_URL="$1"
ACCESS_TOKEN="$2"

# Read post content from STDIN
STATUS=$(cat)

# Check if STATUS is empty
if [[ -z "$STATUS" ]]; then
    echo "Error: No content provided via STDIN."
    exit 1
fi

# Post to Mastodon
curl -sS -X POST "$INSTANCE_URL/api/v1/statuses" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     --form-string "status=$STATUS"
