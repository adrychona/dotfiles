{ config, pkgs, lib, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Materia-dark'
      gsettings set $gnome_schema icon-theme 'Papirus-Dark'
      gsettings set $gnome_schema cursor-theme 'capitaine-cursors'
      gsettings set $gnome_schema font-name 'Jost* 12'
      gsettings set $gnome_schema cursor-size 32

    '';
  };
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'God is dead' --time --cmd sway";
        user = "greeter";
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  environment.etc = {
    "greetd/environments".text = ''
      sway
      fish
    '';
  };
  qt5.enable = true;
  qt5.style = "gtk2";
  qt5.platformTheme = "gtk2";
  environment.systemPackages = with pkgs; [
    capitaine-cursors
    clipman
    configure-gtk
    dbus-sway-environment
    firefox-wayland
    geany
    glib
    greetd.gtkgreet
    grim
    gsimplecal
    imv
    kitty
    materia-theme
    whitesur-icon-theme
    mpv
    neovide
    papirus-icon-theme
    pavucontrol
    pcmanfm
    rofi-wayland
    slurp
    sway
    swayidle
    swaylock-effects
    swaynotificationcenter
    transmission-gtk
    waybar
    wayland
    wl-clipboard
    wlsunset
    wofi
    xarchiver
    zathura
  ];
  fonts.fonts = with pkgs; [
    cascadia-code
    font-awesome
    jost
    nerdfonts
    noto-fonts-emoji
    source-han-mono
    source-han-sans
  ];

  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

}
