{ lib, vscode-extensions, vscode-utils, ... }:

# TODO: Update this with a script or something.
#
# cf. https://github.com/NixOS/nixpkgs/blob/634141959076a8ab69ca2cca0f266852256d79ee/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh
let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  kahole.edamagit = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "edamagit";
      publisher = "kahole";
      version = "0.6.30";
      sha256 = lib.fakeSha256;
    };
  };

  rust-lang.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "rust-analyzer";
      publisher = "rust-lang";
      version = "0.4.1086";
      sha256 = lib.fakeSha256;
    };
  };

  tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "even-better-toml";
      publisher = "tamasfe";
      version = "0.14.2";
      sha256 = lib.fakeSha256;
    };
  };

  trond-snekvik.simple-rst = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "simple-rst";
      publisher = "trond-snekvik";
      version = "1.5.2";
      sha256 = lib.fakeSha256;
    };
  };
in

[
  kahole.edamagit
  rust-lang.rust-analyzer
  tamasfe.even-better-toml
  trond-snekvik.simple-rst
] ++
(with vscode-extensions; [
  bbenoist.nix
  gruntfuggly.todo-tree
  timonwong.shellcheck
  # NOTE: Fix has been merged but not propagated to 'unstable' yet.
  #
  # cf. https://github.com/NixOS/nixpkgs/issues/176697
  vadimcn.vscode-lldb
  vscodevim.vim
])
