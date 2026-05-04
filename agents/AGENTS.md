# Personal Coding Conventions

## Ruby Style

### Line Length
Keep code lines to 120 characters or fewer.

### Variable Names Reflect Class Names
Name variables after the full class name of the object(s) they hold, e.g. `subscriber_address` not `address` for `SubscriberAddress` records.

### Method Call Parentheses
Always use parentheses around method call parameters, e.g. `foo(:bar, baz: qux)` not `foo :bar, baz: qux`.

### No Endless Method Definitions
Never write endless method definitions like `def foo = bar`. Always use the multi-line `def`/`end` form.

### Multi-Line Method Calls
Only split a method call across multiple lines when the single-line form exceeds the 120-char line limit. When split:
- Put the method name and `(` on the first line, with no arguments after `(`.
- Put each argument (including the first positional one) on its own line, indented 2 spaces from the method's column.
- Put the closing `)` on its own line, dedented to the method's column.

### Extract Small Private Helper Methods
Extract small, private helper methods for logic that can be cleanly separated. This keeps methods focused, readable, and reusable.

### Avoid Abbreviations
Use full, descriptive names for variables, methods, and let bindings. Do not abbreviate unless the abbreviation is universally known (e.g., HTML, URL, ID). For example, use `point_of_contact` not `poc`.

## Git

### Never Amend Commits
Always create new commits. Never use `git commit --amend`.

### No Redundant -C Flag
Do not use `git -C <path>` when the current working directory is already the repository root. Just run `git` directly.

## Shell

### Parse JSON with jq
Use `jq` to parse JSON output from CLI commands. Do not pipe CLI output through `python3`, `ruby`, or other languages just to extract fields from JSON.

## RSpec Conventions

- Never set `subject` to anything other than an instance of the described class. Use a named local variable (e.g., `let(:result)`) for other values under test.
- Never use `allow_any_instance_of`.
- Avoid stubbing values in specs.

## PR Workflow

- Never mark PRs as ready for review (always pass `--draft` to `gh pr create`).
- Always use the project's `.github/pull_request_template.md` when creating PRs. Fill in the template sections (e.g. Description, Testing) based on the changes being submitted.

# Project Memory

## Memory Write Policy

Always show the proposed diff and ask the user for permission before writing or updating memory files.
