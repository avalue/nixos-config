{ config, pkgs, ... }:

{
  home.username = "avalue";
  home.homeDirectory = "/home/avalue";
  home.stateVersion = "26.05";

  # Configure Git declaratively (generates ~/.gitconfig)
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Aurimas Valionis";
        email = "aurimas.valionis@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Set up aliases for your modern CLI tools
  home.shellAliases = {
    ls = "eza --icons";
    ll = "eza -lh --icons";
    la = "eza -lah --icons";
    cat = "bat";
    cd = "z"; # Maps standard cd to zoxide
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh-My-Zsh integration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # Classic, clean theme
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
}