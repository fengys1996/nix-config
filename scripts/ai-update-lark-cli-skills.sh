#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/ai-update-lark-cli-skills"
mkdir -p "$state_dir"
exec 9>"$state_dir/update.lock"
if ! flock -n 9; then
  echo "Lark CLI skills update is already running; skipping."
  exit 0
fi

skills_dir="$HOME/.agents/skills"
source_url="https://github.com/larksuite/cli.git"
work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' EXIT

echo "Fetching official Lark CLI skills..."
export GIT_TERMINAL_PROMPT=0
git clone --quiet --depth 1 --filter=blob:none --sparse --branch main \
  "$source_url" "$work_dir/repo"
git -C "$work_dir/repo" sparse-checkout set skills

if [[ ! -s "$work_dir/repo/skills/lark-shared/SKILL.md" ]]; then
  echo "Downloaded skills are missing lark-shared/SKILL.md." >&2
  exit 1
fi

mkdir -p "$skills_dir"
rm -rf -- "$skills_dir"/lark-*
cp -R -- "$work_dir/repo/skills/." "$skills_dir/"
echo "Updated Lark CLI skills in $skills_dir."
