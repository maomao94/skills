#!/usr/bin/env bash
# verify-skills.sh - Verify installed skills for AI editors.
# Checks symlink validity, SKILL.md presence, and provides detailed report.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  cat <<HELP
Usage: $0 [--tool <tool>] [--skill <skill>] [--verbose]

Verify installed skills for AI editors.

Options:
  --tool <tool>       Check only specific tool (opencode, qoder, cursor, claude-code, codex, gemini-cli)
  --skill <skill>     Check only specific skill
  --verbose           Show detailed information about each skill
  --help, -h          Show help.

Examples:
  $0                          # Check all installed skills
  $0 --tool opencode          # Check only OpenCode skills
  $0 --skill caveman          # Check only caveman skill across all tools
  $0 --tool opencode --skill caveman  # Check specific skill in specific tool
  $0 --verbose                # Show detailed information
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
  printf '  %s\n' "$1"
}

success() {
  printf '✓ %s\n' "$1"
}

# Get all possible skill directories for a tool
get_skill_dirs() {
  local tool="$1"
  
  case "$tool" in
    opencode)
      printf '%s/.config/opencode/skills\n' "$HOME"
      if [ -d ".opencode/skills" ]; then
        printf '%s/.opencode/skills\n' "$(pwd)"
      fi
      ;;
    qoder)
      printf '%s/.qoder/skills\n' "$HOME"
      if [ -d ".qoder/skills" ]; then
        printf '%s/.qoder/skills\n' "$(pwd)"
      fi
      ;;
    cursor)
      if [ -d ".cursor/skills" ]; then
        printf '%s/.cursor/skills\n' "$(pwd)"
      fi
      ;;
    claude-code)
      if [ -d ".claude/skills" ]; then
        printf '%s/.claude/skills\n' "$(pwd)"
      fi
      ;;
    codex)
      if [ -d ".codex/skills" ]; then
        printf '%s/.codex/skills\n' "$(pwd)"
      fi
      ;;
    gemini-cli)
      if [ -d ".gemini/commands" ]; then
        printf '%s/.gemini/commands\n' "$(pwd)"
      fi
      ;;
  esac
}

# Check a single skill installation
check_skill() {
  local skill_dir="$1"
  local skill_name="$2"
  local verbose="$3"
  
  local status="ok"
  local issues=()
  
  # Check if directory exists
  if [ ! -d "$skill_dir" ]; then
    warn "$skill_name: directory does not exist"
    return 1
  fi
  
  # Check if it's a symlink
  if [ -L "$skill_dir" ]; then
    local link_target
    link_target="$(readlink "$skill_dir")"
    
    if [ -e "$skill_dir" ]; then
      if [ "$verbose" = true ]; then
        info "Type: symlink -> $link_target"
      fi
    else
      issues+=("broken symlink -> $link_target")
      status="error"
    fi
  elif [ -d "$skill_dir" ]; then
    if [ "$verbose" = true ]; then
      info "Type: copy installation"
    fi
  else
    issues+=("not a directory or symlink")
    status="error"
  fi
  
  # Check for SKILL.md
  if [ -f "$skill_dir/SKILL.md" ]; then
    if [ "$verbose" = true ]; then
      info "SKILL.md: present"
    fi
  else
    issues+=("missing SKILL.md")
    status="error"
  fi
  
  # Check for adapters directory
  if [ -d "$skill_dir/adapters" ]; then
    if [ "$verbose" = true ]; then
      local adapter_count
      adapter_count="$(find "$skill_dir/adapters" -name "*.md" -type f | wc -l | tr -d ' ')"
      info "Adapters: $adapter_count files"
    fi
  elif [ "$verbose" = true ]; then
    info "Adapters: none"
  fi
  
  # Check for scripts directory
  if [ -d "$skill_dir/scripts" ]; then
    if [ "$verbose" = true ]; then
      local script_count
      script_count="$(find "$skill_dir/scripts" -type f | wc -l | tr -d ' ')"
      info "Scripts: $script_count files"
    fi
  elif [ "$verbose" = true ]; then
    info "Scripts: none"
  fi
  
  # Report status
  if [ "$status" = "ok" ]; then
    success "$skill_name"
  else
    warn "$skill_name: ${issues[*]}"
  fi
  
  [ "$status" = "ok" ]
}

# Check all skills for a tool
check_tool() {
  local tool="$1"
  local specific_skill="$2"
  local verbose="$3"
  
  local skill_dirs
  skill_dirs="$(get_skill_dirs "$tool")"
  
  if [ -z "$skill_dirs" ]; then
    if [ "$verbose" = true ]; then
      info "No skill directory found for $tool"
    fi
    return 0
  fi
  
  printf 'Checking %s skills:\n' "$tool"
  
  local found_skills=0
  local failed_skills=0
  
  for skill_dir in $skill_dirs; do
    if [ ! -d "$skill_dir" ]; then
      continue
    fi
    
    # Check each skill in the directory
    for skill_path in "$skill_dir"/*; do
      if [ ! -d "$skill_path" ] && [ ! -L "$skill_path" ]; then
        continue
      fi
      
      local skill_name
      skill_name="$(basename "$skill_path")"
      
      # If specific skill requested, skip others
      if [ -n "$specific_skill" ] && [ "$skill_name" != "$specific_skill" ]; then
        continue
      fi
      
      found_skills=$((found_skills + 1))
      
      if ! check_skill "$skill_path" "$skill_name" "$verbose"; then
        failed_skills=$((failed_skills + 1))
      fi
    done
  done
  
  if [ "$found_skills" -eq 0 ]; then
    if [ -n "$specific_skill" ]; then
      info "Skill '$specific_skill' not found in $tool"
    else
      info "No skills found in $tool"
    fi
  else
    printf '  Found %d skills, %d failed\n' "$found_skills" "$failed_skills"
  fi
  
  [ "$failed_skills" -eq 0 ]
}

main() {
  local specific_tool=""
  local specific_skill=""
  local verbose=false
  
  while [ $# -gt 0 ]; do
    case "$1" in
      --tool)
        specific_tool="${2:-}"
        [ -n "$specific_tool" ] || error '--tool requires a value'
        shift 2
        ;;
      --skill)
        specific_skill="${2:-}"
        [ -n "$specific_skill" ] || error '--skill requires a value'
        shift 2
        ;;
      --verbose)
        verbose=true
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
  
  local tools=("opencode" "qoder" "cursor" "claude-code" "codex" "gemini-cli")
  local total_failed=0
  local valid_tool=false
  
  # If specific tool requested, only check that one
  if [ -n "$specific_tool" ]; then
    for tool in "${tools[@]}"; do
      if [ "$tool" = "$specific_tool" ]; then
        valid_tool=true
        break
      fi
    done
    [ "$valid_tool" = true ] || error "unsupported tool: $specific_tool (supported: ${tools[*]})"

    if ! check_tool "$specific_tool" "$specific_skill" "$verbose"; then
      total_failed=$((total_failed + 1))
    fi
  else
    # Check all tools
    for tool in "${tools[@]}"; do
      if ! check_tool "$tool" "$specific_skill" "$verbose"; then
        total_failed=$((total_failed + 1))
      fi
      printf '\n'
    done
  fi
  
  # Summary
  if [ "$total_failed" -eq 0 ]; then
    success "All skill checks passed"
  else
    warn "$total_failed tool(s) have failed skill checks"
    exit 1
  fi
}

main "$@"
