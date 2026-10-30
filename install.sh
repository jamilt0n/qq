#!/usr/bin/env bash
#
# install.sh - set up qq / qqr
#
#   ./install.sh              install (safe to re-run)
#   ./install.sh --uninstall  remove everything this script added
#
# What it does:
#   1. Links qq and qqr into ~/.local/bin (links, so `git pull` in this folder updates them)
#   2. Adds a small marked block to your shell startup file that
#      - puts ~/.local/bin on your PATH
#      - (zsh only) lets you type ? and * in questions without quotes
#
# It touches nothing outside ~/.local/bin and that one marked block.

set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
bin="$HOME/.local/bin"
begin="# >>> qq >>>"
end="# <<< qq <<<"

green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
red() { printf '\033[31m%s\033[0m\n' "$*" >&2; }

# Pick the startup file for the user's login shell
shell_name="$(basename "${SHELL:-bash}")"
case "$shell_name" in
  zsh)  rc="${ZDOTDIR:-$HOME}/.zshrc" ;;
  bash)
    # macOS Terminal opens login shells, which read ~/.bash_profile, not ~/.bashrc
    # (creating ~/.bash_profile would stop ~/.profile loading, so reuse ~/.profile if that's what exists)
    if [[ "$(uname -s)" != Darwin ]]; then rc="$HOME/.bashrc"
    elif [[ ! -f "$HOME/.bash_profile" && -f "$HOME/.profile" ]]; then rc="$HOME/.profile"
    else rc="$HOME/.bash_profile"; fi ;;
  *)
    red "Your shell is $shell_name. This installer supports zsh and bash."
    red "Manually: put $bin on your PATH, then run qq."
    exit 1 ;;
esac

remove_block() {
  [[ -f "$rc" ]] || return 0
  # delete from begin marker to end marker (portable: no sed -i differences)
  awk -v b="$begin" -v e="$end" '$0==b{skip=1} !skip{print} $0==e{skip=0}' "$rc" > "$rc.qq.tmp"
  cat "$rc.qq.tmp" > "$rc" && rm -f "$rc.qq.tmp"
}

if [[ "${1:-}" == --uninstall ]]; then
  rm -f "$bin/qq" "$bin/qqr"
  remove_block
  green "Removed qq, qqr, and the qq block in $rc."
  echo "Saved answers (if any) are in ${XDG_STATE_HOME:-$HOME/.local/state}/qq. Delete that folder too if you like."
  exit 0
fi

# 1. Link the scripts
mkdir -p "$bin"
chmod +x "$repo/qq" "$repo/qqr"
ln -sf "$repo/qq" "$bin/qq"
ln -sf "$repo/qqr" "$bin/qqr"
green "Linked qq and qqr into $bin"

# 2. Shell startup block (replace any old one so re-running is safe)
touch "$rc"
remove_block
{
  echo "$begin"
  echo "# Added by qq's install.sh ($repo). Remove with: $repo/install.sh --uninstall"
  echo 'case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac'
  [[ "$shell_name" == zsh ]] && echo "alias qq='noglob qq'   # lets you type ? and * without quotes"
  echo "$end"
} >> "$rc"
green "Updated $rc"

# 3. Check for Claude Code
if command -v claude &>/dev/null; then
  green "Found Claude Code: $(command -v claude)"
else
  yellow "Claude Code (the 'claude' command) was not found. qq needs it."
  yellow "Install it from https://docs.anthropic.com/en/docs/claude-code, then run 'claude' once to log in."
fi

echo
green "Done. Open a NEW terminal window (or run: source $rc), then try:"
echo "  qq -h"
echo "  qq how do i list files newest first?"
