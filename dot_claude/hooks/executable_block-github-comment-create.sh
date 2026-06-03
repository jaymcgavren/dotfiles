#!/bin/bash
# Deny `gh api` calls that CREATE a GitHub comment (a POST to a .../comments endpoint).
# Reads (GET of a comments listing) and edits/deletes of other endpoints pass through.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only inspect gh api commands that touch a comments endpoint.
echo "$COMMAND" | grep -q 'gh api' || exit 0
echo "$COMMAND" | grep -q '/comments' || exit 0

# Extract an explicit HTTP method if -X / --method is used.
METHOD=$(echo "$COMMAND" \
  | grep -ioE -- '(-X[[:space:]]*|--method[[:space:]=]+)(GET|POST|PUT|PATCH|DELETE|HEAD)' \
  | grep -ioE '(GET|POST|PUT|PATCH|DELETE|HEAD)' \
  | tr '[:lower:]' '[:upper:]' \
  | tail -1)

# Body-field flags. gh api defaults to POST whenever any of these are present.
HAS_FIELDS=0
if echo "$COMMAND" | grep -qE -- '(^|[[:space:]])(-f|-F|--field|--raw-field|--input)([[:space:]=]|$)'; then
  HAS_FIELDS=1
fi

# Decide whether this command creates a comment.
CREATES=0
if [ -n "$METHOD" ]; then
  [ "$METHOD" = "POST" ] && CREATES=1
elif [ "$HAS_FIELDS" = "1" ]; then
  CREATES=1
fi

if [ "$CREATES" = "1" ]; then
  jq -n '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": "Blocked by local policy: this gh api call creates a GitHub comment (POST to a /comments endpoint). Comment creation is disabled."
    }
  }'
fi

exit 0
