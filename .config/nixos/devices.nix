{ config, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      android-file-transfer
      sshfs
      libimobiledevice
      ifuse
      exfatprogs
      ntfs3g
    ];
    programs.adb.enable = true;
    services.usbmuxd.enable = true;
  };
}
