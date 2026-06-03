#!/bin/bash
# Rewrite "git -C <cwd> ..." to "git ..." when -C points to the current directory

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

CWD=$(echo "$INPUT" | jq -r '.cwd')

# Match: git -C <path> <rest>
if [[ "$COMMAND" =~ ^git\ -C\ ([^\ ]+)(\ .*)$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  REST="${BASH_REMATCH[2]}"

  # Resolve both paths to compare
  RESOLVED_TARGET=$(cd "$TARGET" 2>/dev/null && pwd)
  RESOLVED_CWD=$(cd "$CWD" 2>/dev/null && pwd)

  if [ "$RESOLVED_TARGET" = "$RESOLVED_CWD" ]; then
    REWRITTEN="git${REST}"
    jq -n --arg cmd "$REWRITTEN" \
      '{"hookSpecificOutput":{"hookEventName":"PreToolUse","updatedInput":{"command":$cmd}}}'
  fi
fi
