#!/usr/bin/env bash
set -euo pipefail

# ── Color setup ───────────────────────────────────────────────────────────────
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    BOLD='\033[1m'
    CYAN='\033[36m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    RED='\033[31m'
    GRAY='\033[90m'
    RESET='\033[0m'
else
    BOLD='' CYAN='' GREEN='' YELLOW='' RED='' GRAY='' RESET=''
fi

# ── Resolve paths ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$(cd "$SCRIPT_DIR/../skills" && pwd)"

resolve_install_dir() {
    local path="$1"
    if [[ -L "$path" ]]; then
        readlink -f "$path"
    else
        echo "$path"
    fi
}

TARGETS=("claude" "codex")
declare -A TARGET_NAME
declare -A TARGET_LINK
declare -A TARGET_DIR

TARGET_NAME[claude]="Claude"
TARGET_NAME[codex]="Codex"

TARGET_LINK[claude]="$HOME/.claude/skills"
TARGET_LINK[codex]="${CODEX_HOME:-$HOME/.codex}/skills"

for target in "${TARGETS[@]}"; do
    TARGET_DIR[$target]="$(resolve_install_dir "${TARGET_LINK[$target]}")"
done

# ── Scan skills ───────────────────────────────────────────────────────────────
mapfile -t SKILLS < <(find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

if [[ ${#SKILLS[@]} -eq 0 ]]; then
    echo "No skills found in $SKILLS_SRC" >&2
    exit 1
fi

declare -A SKILL_ACTION
for target in "${TARGETS[@]}"; do
    for skill in "${SKILLS[@]}"; do
        if [[ -d "${TARGET_DIR[$target]}/$skill" ]]; then
            SKILL_ACTION["$target:$skill"]="update"
        else
            SKILL_ACTION["$target:$skill"]="install"
        fi
    done
done

# ── Header ────────────────────────────────────────────────────────────────────
echo
echo -e "${BOLD}Skills Installer${RESET}"
echo -e "${GRAY}────────────────${RESET}"
for target in "${TARGETS[@]}"; do
    echo -e "${TARGET_NAME[$target]} destination: ${CYAN}${TARGET_LINK[$target]}/${RESET}"
done
echo

echo "Skills to install:"
printf "  ${BOLD}%-24s %-8s %-8s${RESET}\n" "Skill" "Claude" "Codex"
printf "  %-24s %-8s %-8s\n" "-----" "------" "-----"
for skill in "${SKILLS[@]}"; do
    claude_action="${SKILL_ACTION["claude:$skill"]}"
    codex_action="${SKILL_ACTION["codex:$skill"]}"

    printf -v claude_padded "%-8s" "$claude_action"
    printf -v codex_padded "%-8s" "$codex_action"

    if [[ "$claude_action" == "update" ]]; then
        claude_cell="${YELLOW}${claude_padded}${RESET}"
    else
        claude_cell="${GREEN}${claude_padded}${RESET}"
    fi

    if [[ "$codex_action" == "update" ]]; then
        codex_cell="${YELLOW}${codex_padded}${RESET}"
    else
        codex_cell="${GREEN}${codex_padded}${RESET}"
    fi

    printf "  ${CYAN}%-24s${RESET} %b %b\n" "$skill" "$claude_cell" "$codex_cell"
done

# ── Confirmation ──────────────────────────────────────────────────────────────
echo
printf "Proceed? [y/N] "
read -r answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# ── Install ───────────────────────────────────────────────────────────────────
for target in "${TARGETS[@]}"; do
    mkdir -p "${TARGET_DIR[$target]}"
done

echo
echo "Installing..."

total_success=0
total_failure=0
declare -A TARGET_SUCCESS
declare -A TARGET_FAILURE

for target in "${TARGETS[@]}"; do
    TARGET_SUCCESS[$target]=0
    TARGET_FAILURE[$target]=0
done

for target in "${TARGETS[@]}"; do
    for skill in "${SKILLS[@]}"; do
        if cp -r "$SKILLS_SRC/$skill" "${TARGET_DIR[$target]}/" 2>/dev/null; then
            echo -e "  ${GREEN}✓${RESET} [${TARGET_NAME[$target]}] $skill"
            (( total_success++ )) || true
            (( TARGET_SUCCESS[$target]++ )) || true
        else
            echo -e "  ${RED}✗${RESET} [${TARGET_NAME[$target]}] $skill"
            (( total_failure++ )) || true
            (( TARGET_FAILURE[$target]++ )) || true
        fi
    done
done

# ── Summary ───────────────────────────────────────────────────────────────────
echo
if [[ $total_failure -eq 0 ]]; then
    for target in "${TARGETS[@]}"; do
        count="${TARGET_SUCCESS[$target]}"
        echo -e "${GREEN}${TARGET_NAME[$target]}: ${count} skill$([ "$count" -ne 1 ] && echo s) installed successfully.${RESET}"
    done
    echo -e "${GREEN}Total: ${total_success} install actions completed.${RESET}"
    echo -e "${GRAY}Relaunch any running Claude or Codex instances for new skills to take effect.${RESET}"
else
    for target in "${TARGETS[@]}"; do
        success_count="${TARGET_SUCCESS[$target]}"
        failure_count="${TARGET_FAILURE[$target]}"
        echo -e "${YELLOW}${TARGET_NAME[$target]}: ${success_count} installed, ${RED}${failure_count} failed.${RESET}"
    done
    echo -e "${YELLOW}Total: ${total_success} installed, ${RED}${total_failure} failed.${RESET}"
    exit 1
fi
