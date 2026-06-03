#!/usr/bin/env bash

set -e

HOST_NAME="${1:-ASPIRE}"
BASHRC="$HOME/.bashrc"

echo "Configuring prompt with hostname: [$HOST_NAME]..."

if [ -f "$BASHRC" ]; then
    sed -i '/# --- CUSTOM GIT PROMPT CONFIG ---/,/# --- END CUSTOM GIT PROMPT ---/d' "$BASHRC"
fi

cat << 'EOF' >> "$BASHRC"

# --- CUSTOM GIT PROMPT CONFIG ---
get_git_details() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch=$(git branch --show-current 2>/dev/null)
        local hash=$(git rev-parse --short HEAD 2>/dev/null)
        
        # FIX: Remove raw ANSI color escape codes from the function output. 
        # Only echo plain text here.
        echo -n "[${branch}]->(${hash}): "
    fi
}
EOF

# FIX: Wrap the dynamic function call inside the color escape codes directly in PS1.
# \[\e[1;31m\] starts hot red right before the Git details, and \[\e[0m\] resets it immediately after.
echo "export PS1='\[\e[1;32m\][\A $HOST_NAME]:\[\e[1;31m\]\$(get_git_details)\[\e[1;34m\]\w\[\e[0m\]\\\$ '" >> "$BASHRC"
echo "# --- END CUSTOM GIT PROMPT ---" >> "$BASHRC"

echo "Success! Changes written to $BASHRC."
echo "Please run 'source ~/.bashrc' to apply the changes."
