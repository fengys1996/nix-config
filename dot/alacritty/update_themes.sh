#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
themes_dir="${script_dir}/themes"
themes_repo="https://github.com/alacritty/alacritty-theme.git"

rm -rf -- "${themes_dir}"
git clone --depth 1 "${themes_repo}" "${themes_dir}"
rm -rf -- "${themes_dir}/.git"
