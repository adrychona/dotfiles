{ config, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      krita
      gimp
      keepassxc
      obs-studio
      openrgb
    ];

  };
}
