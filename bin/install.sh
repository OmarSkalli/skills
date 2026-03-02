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

CLAUDE_SKILLS="$HOME/.claude/skills"
if [[ -L "$CLAUDE_SKILLS" ]]; then
    INSTALL_DIR="$(readlink -f "$CLAUDE_SKILLS")"
else
    INSTALL_DIR="$CLAUDE_SKILLS"
fi

# ── Scan skills ───────────────────────────────────────────────────────────────
mapfile -t SKILLS < <(find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

if [[ ${#SKILLS[@]} -eq 0 ]]; then
    echo "No skills found in $SKILLS_SRC" >&2
    exit 1
fi

declare -A SKILL_ACTION
for skill in "${SKILLS[@]}"; do
    if [[ -d "$INSTALL_DIR/$skill" ]]; then
        SKILL_ACTION[$skill]="update"
    else
        SKILL_ACTION[$skill]="install"
    fi
done

# ── Header ────────────────────────────────────────────────────────────────────
echo
echo -e "${BOLD}Skills Installer${RESET}"
echo -e "${GRAY}────────────────${RESET}"
echo -e "Install destination: ${CYAN}${CLAUDE_SKILLS}/${RESET}"
echo

echo "Skills to install:"
for skill in "${SKILLS[@]}"; do
    action="${SKILL_ACTION[$skill]}"
    if [[ "$action" == "update" ]]; then
        badge="${YELLOW}update${RESET}"
    else
        badge="${GREEN}install${RESET}"
    fi
    printf "  ${BOLD}✦${RESET} ${CYAN}%-24s${RESET} %b\n" "$skill" "$badge"
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
mkdir -p "$INSTALL_DIR"

echo
echo "Installing..."

success=0
failure=0

for skill in "${SKILLS[@]}"; do
    if cp -r "$SKILLS_SRC/$skill" "$INSTALL_DIR/" 2>/dev/null; then
        echo -e "  ${GREEN}✓${RESET} $skill"
        (( success++ )) || true
    else
        echo -e "  ${RED}✗${RESET} $skill"
        (( failure++ )) || true
    fi
done

# ── Summary ───────────────────────────────────────────────────────────────────
echo
if [[ $failure -eq 0 ]]; then
    echo -e "${GREEN}${success} skill$([ "$success" -ne 1 ] && echo s) installed successfully.${RESET}"
    echo -e "${GRAY}Relaunch any running Claude instances for new skills to take effect.${RESET}"
else
    echo -e "${YELLOW}${success} installed, ${RED}${failure} failed.${RESET}"
    exit 1
fi
