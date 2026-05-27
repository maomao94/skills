#!/usr/bin/env bash
# install-skill.sh - Generic skill installer for AI editors.
# Supports symlink and copy installation for OpenCode, Qoder, and other tools.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  cat <<HELP
Usage: $0 --skill <skill-name> --tool <tool> [--source <path>] [--project <path>] [--link|--copy] [--uninstall] [--status]

Install a skill into an AI editor skill directory.

Tools (user-level by default, project-level with --project):
  opencode     ~/.config/opencode/skills/<skill> or <project>/.opencode/skills/<skill>
  qoder        ~/.qoder/skills/<skill> or <project>/.qoder/skills/<skill>

Tools (project-level, require --project):
  cursor       <project>/.cursor/skills/<skill>
  claude-code  <project>/.claude/skills/<skill>
  codex        <project>/.codex/skills/<skill>
  gemini-cli   <project>/.gemini/commands/<skill>

Options:
  --skill <name>      Required skill name (ignored with --list).
  --tool <tool>       Target tool (ignored with --list).
  --source <path>     Source directory containing the skill. Default: skills/<skill-name>
  --project <path>    Project root for project-level installs.
                       Required for cursor, claude-code, codex, gemini-cli.
                       Optional for opencode and qoder.
  --link              Create symlink (default).
  --copy              Copy files instead of creating a symlink.
  --uninstall         Remove installed skill.
  --status            Show installation status without making changes.
  --list              List all available skills in this repository.
  --help, -h          Show help.

Examples:
  $0 --skill caveman --tool opencode
  $0 --skill caveman --tool opencode --source /path/to/skills/caveman
  $0 --skill caveman --tool qoder --copy
  $0 --skill caveman --tool cursor --project /path/to/project
  $0 --skill caveman --tool gemini-cli --project /path/to/project
  $0 --skill caveman --tool opencode --status
  $0 --skill caveman --tool opencode --uninstall
  $0 --list
HELP
}

error() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

warn() {
  printf 'warning: %s\n' "$1" >&2
}

info() {
  printf '%s\n' "$1"
}

success() {
  printf '✓ %s\n' "$1"
}

# Determine source directory for a skill
resolve_source_dir() {
  local skill="$1"
  local source="${2:-}"
  
  if [ -n "$source" ]; then
    # User provided explicit source
    if [ ! -d "$source" ]; then
      error "source directory does not exist: $source"
    fi
    # Check if source contains SKILL.md
    if [ ! -f "$source/SKILL.md" ]; then
      error "source directory does not contain SKILL.md: $source"
    fi
    printf '%s' "$source"
  else
    # Default: look in skills/ directory relative to this script
    local default_source="$SCRIPT_DIR/$skill"
    if [ ! -d "$default_source" ]; then
      error "skill directory not found: $default_source (use --source to specify)"
    fi
    if [ ! -f "$default_source/SKILL.md" ]; then
      error "skill directory does not contain SKILL.md: $default_source"
    fi
    printf '%s' "$default_source"
  fi
}

# Determine target directory for a tool
target_dir_for() {
  local tool="$1"
  local skill="$2"
  local project="${3:-}"

  case "$tool" in
    opencode)
      if [ -n "$project" ]; then
        printf '%s/.opencode/skills/%s\n' "$project" "$skill"
      else
        printf '%s/.config/opencode/skills/%s\n' "$HOME" "$skill"
      fi
      ;;
    qoder)
      if [ -n "$project" ]; then
        printf '%s/.qoder/skills/%s\n' "$project" "$skill"
      else
        printf '%s/.qoder/skills/%s\n' "$HOME" "$skill"
      fi
      ;;
    cursor)
      [ -n "$project" ] || error '--project is required for --tool cursor'
      printf '%s/.cursor/skills/%s\n' "$project" "$skill"
      ;;
    claude-code)
      [ -n "$project" ] || error '--project is required for --tool claude-code'
      printf '%s/.claude/skills/%s\n' "$project" "$skill"
      ;;
    codex)
      [ -n "$project" ] || error '--project is required for --tool codex'
      printf '%s/.codex/skills/%s\n' "$project" "$skill"
      ;;
    gemini-cli)
      [ -n "$project" ] || error '--project is required for --tool gemini-cli'
      printf '%s/.gemini/commands/%s\n' "$project" "$skill"
      ;;
    *)
      error "unsupported tool: $tool (supported: opencode, qoder, cursor, claude-code, codex, gemini-cli)"
      ;;
  esac
}

# Check installation status
check_status() {
  local target="$1"
  local skill="$2"
  
  if [ -L "$target" ]; then
    local link_target
    link_target="$(readlink "$target")"
    if [ -e "$target" ]; then
      success "$skill: symlink -> $link_target (valid)"
    else
      warn "$skill: symlink -> $link_target (broken)"
    fi
  elif [ -d "$target" ]; then
    if [ -f "$target/SKILL.md" ]; then
      success "$skill: copy installation (valid)"
    else
      warn "$skill: copy installation (missing SKILL.md)"
    fi
  else
    info "$skill: not installed"
  fi
}

# Install skill
install_skill() {
  local source="$1"
  local target="$2"
  local use_copy="$3"
  local skill="$4"

  # Create target parent directory
  mkdir -p "$(dirname "$target")"
  
  # Remove existing installation
  if [ -L "$target" ] || [ -d "$target" ]; then
    rm -rf "$target"
  fi

  # Install
  if [ "$use_copy" = true ]; then
    cp -R "$source" "$target"
  else
    ln -s "$source" "$target"
  fi

  # Verify installation
  if [ ! -f "$target/SKILL.md" ]; then
    error "installed skill is missing SKILL.md: $target"
  fi
  
  success "$skill installed -> $target"
}

# Uninstall skill
uninstall_skill() {
  local target="$1"
  local skill="$2"
  
  if [ -L "$target" ] || [ -d "$target" ]; then
    rm -rf "$target"
    success "$skill uninstalled"
  else
    info "$skill: not installed"
  fi
}

# List all available skills in this repository
list_skills() {
  local skills_dir="$SCRIPT_DIR"
  printf 'Available skills:\n'
  local found=0
  for skill_dir in "$skills_dir"/*/; do
    [ -d "$skill_dir" ] || continue
    local skill_name
    skill_name="$(basename "$skill_dir")"
    # Skip non-skill directories
    if [ -f "$skill_dir/SKILL.md" ]; then
      printf '  - %s\n' "$skill_name"
      found=1
    fi
  done
  if [ "$found" -eq 0 ]; then
    printf '  (none found)\n'
  fi
}

main() {
  local skill=''
  local tool=''
  local source=''
  local project=''
  local use_copy=false
  local uninstall=false
  local status=false
  local list=false

  while [ $# -gt 0 ]; do
    case "$1" in
      --skill)
        skill="${2:-}"
        [ -n "$skill" ] || error '--skill requires a value'
        shift 2
        ;;
      --tool)
        tool="${2:-}"
        [ -n "$tool" ] || error '--tool requires a value'
        shift 2
        ;;
      --source)
        source="${2:-}"
        [ -n "$source" ] || error '--source requires a value'
        shift 2
        ;;
      --project)
        project="${2:-}"
        [ -n "$project" ] || error '--project requires a value'
        shift 2
        ;;
      --copy)
        use_copy=true
        shift
        ;;
      --link)
        use_copy=false
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
      --list)
        list=true
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

  if [ "$list" = true ]; then
    list_skills
    exit 0
  fi

  [ -n "$skill" ] || error '--skill is required (use --list to see available skills)'
  [ -n "$tool" ] || error '--tool is required (supported: opencode, qoder, cursor, claude-code, codex, gemini-cli)'

  # Resolve source directory
  local source_dir
  source_dir="$(resolve_source_dir "$skill" "$source")"

  # Determine target directory
  local target_dir
  target_dir="$(target_dir_for "$tool" "$skill" "$project")"

  # Execute action
  if [ "$status" = true ]; then
    check_status "$target_dir" "$skill"
  elif [ "$uninstall" = true ]; then
    uninstall_skill "$target_dir" "$skill"
  else
    install_skill "$source_dir" "$target_dir" "$use_copy" "$skill"
  fi
}

main "$@"
