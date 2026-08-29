{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # --- 1. BOOT & MAC PRO 5,1 NVRAM PROTECTIONS (CRITICAL) ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.blacklistedKernelModules = [ "pstore" ];

  # --- 2. MEMORY MANAGEMENT ---
  zramSwap.enable = true;

  # --- 3. NETWORKING & WI-FI ---
  networking.hostName = "macpro"; 
  networking.networkmanager.enable = true;

  # Allow unfree packages and permit the insecure Broadcom driver
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.18.47"
  ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # --- 4. LOCALE & LANGUAGE ---
  time.timeZone = "Europe/Vilnius";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "lt_LT.UTF-8";
    LC_IDENTIFICATION = "lt_LT.UTF-8";
    LC_MEASUREMENT = "lt_LT.UTF-8";
    LC_MONETARY = "lt_LT.UTF-8";
    LC_NAME = "lt_LT.UTF-8";
    LC_NUMERIC = "lt_LT.UTF-8";
    LC_PAPER = "lt_LT.UTF-8";
    LC_TELEPHONE = "lt_LT.UTF-8";
    LC_TIME = "lt_LT.UTF-8";
  };

  # --- 5. KEYBOARD LAYOUT & TTY ---
  services.xserver.xkb = {
    layout = "us"; 
  };
  
  console = {
    useXkbConfig = true; 
  };

  # --- 6. BLUETOOTH & LOGITECH K380 ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.enableRedistributableFirmware = true;  

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # --- 7. USER ACCOUNT & REMOTE ACCESS ---
  users.users.avalue = {
    isNormalUser = true;
    description = "Aurimas Valionis";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "temporaryPassword123";
  };
  
  security.sudo.enable = true;

  # Enable SSH for remote configuration from macOS
  services.openssh.enable = true;

  # --- 8. HEADLESS ENVIRONMENT (NO GUI YET) ---
  services.xserver.enable = false;

  # --- 9. SYSTEM PACKAGES & FLAKES ---
  environment.systemPackages = with pkgs; [
    git
    vim     # or neovim
    wget
    curl
    htop
    # Modern CLI toolkit
    eza
    bat
    fd
    ripgrep
    zoxide
    yazi
  ]; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}