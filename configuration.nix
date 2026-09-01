{ config, pkgs, ... }:

{
  # --- 1. BOOT & MAC PRO 5,1 NVRAM PROTECTIONS (CRITICAL) ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.blacklistedKernelModules = [ "pstore" ];

  # --- 2. MEMORY MANAGEMENT ---
  zramSwap.enable = true;

  # --- 3. NETWORKING & WI-FI ---
  networking.hostName = "macpro";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.18.47"
  ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # --- 4. LOCALE & LANGUAGE ---
  time.timeZone = "Europe/Vilnius";
  time.hardwareClockInLocalTime = true;

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
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;

  # --- 6. BLUETOOTH & OPENLOGI ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.enableRedistributableFirmware = true;

  programs.openlogi.enable = true;

  # --- 7. USER ACCOUNT & REMOTE ACCESS ---
  programs.zsh.enable = true;

  users.users.avalue = {
    isNormalUser = true;
    description = "Aurimas Valionis";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "temporaryPassword123";
    shell = pkgs.zsh;
  };

  security.sudo.enable = true;
  services.openssh.enable = true;

  # --- 8. GRAPHICS & DESKTOP ENVIRONMENT ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # --- 9. SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
  ];

  # --- 10. NIX STORE MANAGEMENT ---
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}