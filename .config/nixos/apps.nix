{ config, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [ keepassxc obs-studio ];

  };
}
