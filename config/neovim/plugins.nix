{
  lib,
  pkgs,
  ...
}:
# TODO: Source this from a JSON file and write an update script.
#
# cf. The Plex Server 'update.sh'.
{
  gruvbox-material = pkgs.vimUtils.buildVimPlugin {
    name = "gruvbox-material";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "gruvbox-material";
      rev = "2807579bd0a9981575dbb518aa65d3206f04ea02";
      sha256 = "/Jv/V5VkG2F7KZ4XJys0TILBWcMacVEsoCY5ul6obas=";
    };
  };
  # TODO: patch this to disable `luacheck` stuff.
  lualine = pkgs.vimUtils.buildVimPlugin {
    name = "lualine";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "edca2b03c724f22bdc310eee1587b1523f31ec7c";
      sha256 = "S9TFHqmweVZriNpW7Si0sy6ioa+pu2A8kxC6N7w0/hk=";
    };
  };
}
