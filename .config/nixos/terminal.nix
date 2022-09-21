{ config, pkgs, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      bluez-tools
      brightnessctl
      btop
      cava
      chezmoi
      cmake
      cmatrix
      ddcutil
      exa
      fdupes
      ffmpeg
      git
      glow
      gping
      imagemagick
      jq
      libnotify
      libsecret
      mpc_cli
      ncmpcpp
      neofetch
      nixfmt
      nodePackages.coc-prettier
      nodejs
      openssl
      pfetch
      pipes-rs
      procs
      pulseaudio
      pv
      python3
      ranger
      slurp
      starship
      stow
      unzip
      wget
      xdg-user-dirs
      yt-dlp
      zip
      zoxide
      android-tools
    ];
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "unrar" ];
    nixpkgs.overlays = [
      (self: super: {
        ncmpcpp = super.ncmpcpp.override {
          visualizerSupport = true;
          clockSupport = true;
        };
      })
    ];

  };
}
