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
    ./emacs.nix
    /etc/nixos/hardware-configuration-zfs.nix
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
    plymouth = { enable = true; };
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/";
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 0;
      efi.efiSysMountPoint = "/boot";
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "i2c-dev" ];
  };
  networking.hostName = "cobalto-negro";
  networking.hostId = "8556b001";
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  # ...
  console = { keyMap = "us"; };
  #HW Specific
  hardware.i2c.enable = true;
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" ];
  };

}
