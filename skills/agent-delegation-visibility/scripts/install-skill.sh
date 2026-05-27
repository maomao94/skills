#!/usr/bin/env bash
# install-skill.sh - install agent-delegation-visibility into AI editor skill directories.
# This script calls the generic installer skills/install-skill.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GENERIC_INSTALLER="$SKILLS_DIR/install-skill.sh"

show_help() {
  cat <<HELP
Usage: $0 --tool <tool> [--link] [--copy] [--uninstall] [--status]

Install agent-delegation-visibility into an AI editor skill directory.

Tools:
  opencode     ~/.config/opencode/skills/<skill>
  qoder        ~/.qoder/skills/<skill>
  cursor       <project>/.cursor/skills/<skill>
  claude-code  <project>/.claude/skills/<skill>
  codex        <project>/.codex/skills/<skill>
  gemini-cli   <project>/.gemini/commands/<skill>

Options:
  --tool <tool>       Required target tool.
  --project <path>    Required for project-level tools: cursor, claude-code, codex, gemini-cli.
  --link              Create symlink (default).
  --copy              Copy files instead of creating a symlink.
  --uninstall         Remove installed skill.
  --status            Show installation status without making changes.
  --help, -h          Show help.

Examples:
  $0 --tool opencode
  $0 --tool qoder --copy
  $0 --tool cursor --project /path/to/project --copy
  $0 --tool opencode --status
  $0 --tool opencode --uninstall

Note: This script calls the generic installer $GENERIC_INSTALLER
HELP
}

error() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

# Check generic installer exists and is executable
check_generic_installer() {
  if [ ! -f "$GENERIC_INSTALLER" ]; then
    error "generic installer not found: $GENERIC_INSTALLER"
  fi
  
  if [ ! -x "$GENERIC_INSTALLER" ]; then
    error "generic installer is not executable: $GENERIC_INSTALLER"
  fi
}

main() {
  local tool=''
  local project=''
  local use_copy=false
  local uninstall=false
  local status=false

  while [ $# -gt 0 ]; do
    case "$1" in
      --tool)
        tool="${2:-}"
        [ -n "$tool" ] || error '--tool requires a value'
        shift 2
        ;;
      --project)
        project="${2:-}"
        [ -n "$project" ] || error '--project requires a value'
        shift 2
        ;;
      --link)
        use_copy=false
        shift
        ;;
      --copy)
        use_copy=true
        shift
        ;;
      --uninstall)
        uninstall=true
        shift
        ;;
      --status)
        status=true
        shift
        ;;
      --help|-h)
        show_help
        exit 0
        ;;
      *)
        error "unknown argument: $1"
        ;;
    esac
  done

  [ -n "$tool" ] || error '--tool is required'

  # Check generic installer
  check_generic_installer

  # Build arguments for generic installer
  local args=()
  args+=("--skill" "agent-delegation-visibility")
  args+=("--tool" "$tool")
  
  if [ -n "$project" ]; then
    args+=("--project" "$project")
  fi
  
  if [ "$use_copy" = true ]; then
    args+=("--copy")
  fi
  
  if [ "$uninstall" = true ]; then
    args+=("--uninstall")
  fi
  
  if [ "$status" = true ]; then
    args+=("--status")
  fi
  
  # Call generic installer
  "$GENERIC_INSTALLER" "${args[@]}"
}

main "$@"