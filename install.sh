#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Claude Code config from $REPO_DIR..."

# --- submodules ---
git -C "$REPO_DIR" submodule update --init --recursive

# --- statusline ---
if [ -d "$CLAUDE_DIR/statusline" ] && [ ! -L "$CLAUDE_DIR/statusline" ]; then
    echo "Backing up existing statusline to $CLAUDE_DIR/statusline.bak"
    mv "$CLAUDE_DIR/statusline" "$CLAUDE_DIR/statusline.bak"
fi
ln -sfn "$REPO_DIR/statusline" "$CLAUDE_DIR/statusline"
chmod +x "$REPO_DIR/statusline/statusline.sh"
echo "  statusline -> $CLAUDE_DIR/statusline"

# --- skills ---
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$REPO_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    target="$CLAUDE_DIR/skills/$skill_name"
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing skill $skill_name to ${target}.bak"
        mv "$target" "${target}.bak"
    fi
    ln -sfn "$skill_dir" "$target"
    echo "  skill: $skill_name -> $target"
done

# --- settings.json ---
settings_target="$CLAUDE_DIR/settings.json"
if [ -f "$settings_target" ]; then
    echo "Backing up existing settings.json to $CLAUDE_DIR/settings.json.bak"
    cp "$settings_target" "$CLAUDE_DIR/settings.json.bak"
fi
cp "$REPO_DIR/settings.json" "$settings_target"
echo "  settings.json -> $settings_target"

# --- keybindings.json ---
kb_target="$CLAUDE_DIR/keybindings.json"
if [ -f "$kb_target" ]; then
    echo "Backing up existing keybindings.json to $CLAUDE_DIR/keybindings.json.bak"
    cp "$kb_target" "$CLAUDE_DIR/keybindings.json.bak"
fi
cp "$REPO_DIR/keybindings.json" "$kb_target"
echo "  keybindings.json -> $kb_target"

echo ""
echo "Done. Restart Claude Code for changes to take effect."
