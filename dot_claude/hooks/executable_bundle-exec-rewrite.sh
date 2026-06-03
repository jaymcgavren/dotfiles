#!/bin/bash
# Rewrite bin/<cmd> to bundle exec <cmd> for common Ruby tools

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

REWRITTEN="$COMMAND"
REWRITTEN="${REWRITTEN//bin\/rails/bundle exec rails}"
REWRITTEN="${REWRITTEN//bin\/rspec/bundle exec rspec}"
REWRITTEN="${REWRITTEN//bin\/rubocop/bundle exec rubocop}"
REWRITTEN="${REWRITTEN//bin\/rake/bundle exec rake}"

if [ "$COMMAND" != "$REWRITTEN" ]; then
  jq -n --arg cmd "$REWRITTEN" \
    '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":$cmd}}}'
fi
