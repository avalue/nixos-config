{ pkgs, ... }:

{
  home.username = "avalue";
  home.homeDirectory = "/home/avalue";
  home.stateVersion = "26.05";

  # Configure Git declaratively 
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
    cat = "bat";
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
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  # Modern CLI toolkit
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ]; # Safely replaces the native cd command
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  # Terminal file manager and its search dependencies
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  home.packages = with pkgs; [
    google-chrome
    microsoft-edge
    obsidian
    libreoffice-qt6
    # zoom-us
    # discord
    vscode-fhs
    jetbrains.idea
    kdePackages.kweather
    kdePackages.korganizer
    kdePackages.kdepim-runtime
  ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Abernathy";
      background-opacity = "0.95";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
}
