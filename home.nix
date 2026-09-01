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
    vscode-fhs
    jetbrains.idea
    kdePackages.kweather
    kdePackages.korganizer
    kdePackages.kdepim-runtime
    wofi
    wl-clipboard
    hyprpaper
    mako
    grim
    slurp
    kdePackages.polkit-kde-agent-1
    font-awesome # Fixes the missing icon squares
    psmisc
  ];

  # Enable fonts for Home Manager
  fonts.fontconfig.enable = true;

  # Replace the raw waybar package with a customized module
  programs.waybar = {
    enable = true;
    
    # Define the layout and modules
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "default" = "";
          };
        };

        "clock" = {
          format = "{:%H:%M - %Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
        };

        "network" = {
          format = "Ethernet ";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-disconnected = "Disconnected ⚠";
        };
      };
    };

    # Keep your existing custom CSS
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Font Awesome 6 Free", "Font Awesome 6 Brands", Roboto, Helvetica, Arial, sans-serif;
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(30, 30, 46, 0.9);
          color: #cdd6f4;
      }

      #workspaces button {
          padding: 0 10px;
          background: transparent;
          color: #cdd6f4;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
          background-color: #89b4fa;
          color: #1e1e2e;
      }

      #clock, #pulseaudio, #network, #tray, #window {
          padding: 0 15px;
          background-color: transparent;
          color: #cdd6f4;
      }
    '';
  };

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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "hyprlang";
    extraConfig = ''
      $mod = SUPER
      monitor = ,preferred,auto,1

      # --- Autostart Daemons ---
      exec-once = waybar
      exec-once = hyprpaper
      exec-once = mako
      exec-once = ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1

      # --- Essential Programs ---
      bind = $mod, T, exec, ghostty
      bind = $mod, Space, exec, wofi --show drun
      bind = $mod, Q, killactive
      bind = $mod, M, exit

      # --- Screenshots & Media ---
      # SUPER + S: Select area to screenshot and copy to clipboard
      bind = $mod, S, exec, grim -g "$(slurp)" - | wl-copy
      
      # Audio control using standard hardware keys
      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # --- Window Navigation ---
      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d

      # --- Workspace Navigation ---
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4

      # --- Move Windows to Workspaces ---
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      
      # --- Window Layout ---
      bind = $mod, V, togglefloating, 
      bind = $mod, F, fullscreen, 
    '';
  };
}
