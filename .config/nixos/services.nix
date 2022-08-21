{ config, pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "diego";

      dataDir = "/home/diego";

      configDir = "/home/diego/.config/syncthing";
    };
    transmission = {
      user = "diego";
      enable = true;
      home = "/mnt/mainStorage/transmission";
      settings = {
        openRPCPort = true;
        rpc-bind-adress = "0.0.0.0";
        watch-dir-enabled = true;
        watch-dir = "${config.users.users.diego.home}/Downloads";
        downloadDirPermissions = "770";
        umask = 18;
        trash-original-torrent-files = true;
        credentialsFile =
          "/mnt/mainStorage/transmission/.secrets/credentials.json";
      };
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    openssh.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
    usbmuxd.enable = true;
    gnome.gnome-keyring.enable = true;
    mpd = {
      enable = true;
      user = "diego";
      musicDirectory = "/home/diego/Music";
      extraConfig = ''
          audio_output {
           type "pipewire"
           name "My PipeWire Output"
         } 
          audio_output {
              type            "fifo"
               name            "Visualizer feed"
                path            "/tmp/mpd.fifo"
               format          "44100:16:2"
        }
      '';

      # Optional:
      network.listenAddress =
        "any"; # if you want to allow non-localhost connections
      #  startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };

  };
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez5-experimental;
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR =
      "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };

}

