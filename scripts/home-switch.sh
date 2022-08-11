#!/usr/bin/env sh

set -eu

machine=${1:-$(hostname -s)}

CONFIG_PATH="${HOME}/.config/dotfiles"

nix build \
  --experimental-features 'flakes nix-command' \
  --show-trace \
  --no-link "${CONFIG_PATH}/#homeConfigurations.${machine}.activationPackage"

result=$(
  nix path-info \
    --extra-experimental-features 'flakes nix-command' \
    "${CONFIG_PATH}/#homeConfigurations.${machine}.activationPackage"
)

"${result}/activate"
