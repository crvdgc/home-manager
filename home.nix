{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ubikium";
  home.homeDirectory = "/home/ubikium";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
  nixpkgs.overlays = [(final: _: {
    nix = final.nixUnstable;
    # nix-direnv = (import <unstable> {}).nix-direnv.override {
    #   enableFlakes = true;
    #   nixUnstable = pkgs.nixUnstable;
    #   nixStable = pkgs.nixUnstable;
    # };
    nix-direnv = final.callPackage <unstable/pkgs/tools/misc/nix-direnv> { };
  })];

  home.packages = with pkgs; [
    unzip

    # editors
    neovim
    nodejs  # for coc.vim
    yarn
    stylish-haskell

    # agda environments
    # agda
  ];

  programs.git = {
    enable = true;
    userName = "crvdgc";
    userEmail = "ubikium@gmail.com";
  };

  # programs.emacs = {
  #   enable = true;
  #   extraPackages = (
  #    epkgs: (with epkgs; [
  #           ])
  #     );
  # };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file = {
    ".local/share/nvim/site/autoload/plug.vim".source = ./vim/plug.vim;

    ".config/nvim/init.vim".source = ./vim/init.vim;
    ".config/nvim/colors/molokai.vim".source = ./vim/molokai.vim;
    ".config/nvim/coc-settings.json".source = ./vim/coc-settings.json;

    ".bashrc".source = ./bash/bashrc;
    ".git-prompt.sh".source = ./bash/git-prompt.sh;

    ".direnvrc".source = ./direnvrc.sh;
  };
}
