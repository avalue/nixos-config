{ config, pkgs, ... }:

{
  home.username = "avalue";
  home.homeDirectory = "/home/avalue";
  home.stateVersion = "26.05";

  # Configure Git declaratively (generates ~/.gitconfig)
  programs.git = {
    enable = true;
    userName = "Aurimas Valionis";
    userEmail = "aurimas.valionis@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
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
}