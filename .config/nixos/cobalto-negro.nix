{ config, pkgs, ... }: {
  imports = [
    ./apps.nix
    ./devices.nix
    ./environment.nix
    ./gaming.nix
    ./hosts.nix
    ./proaudio.nix
    ./services.nix
    ./sway.nix
    ./terminal.nix
    ./users.nix
    ./virtmanager.nix
    ./emacs.nix
  ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-22.05";
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
    ];
    plymouth = {

      enable = true;
      theme = "solar";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      grub = {
        enable = true;
        device = "nodev";

     efiSupport = true;
      };
      timeout = 0;
      efi.efiSysMountPoint = "/boot/efi";
      efi.canTouchEfiVariables = true;
    };
  };
  networking.hostName = "cobalto-negro";
  networking.hostId = "8556b001";
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  console = { keyMap = "us"; };
  hardware.i2c.enable = true;
  environment.systemPackages = [pkgs.linux-firmware];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];

    "/swap".options = [ "noatime" ];
  };
swapDevices = [ { device = "/swap/swapfile"; } ];
}
