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
  flake-compat = builtins.fetchTarball
    "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball
      "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;

  sway-polkit = pkgs.writeTextFile {
    name = "sway-polkit";
    destination = "/bin/sway-polkit";
    executable = true;

    text = ''

      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

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
          currenttime=$(date +%H:%M)

            gnome_schema=org.gnome.desktop.interface
            export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
          if [[ "$currenttime" > "19:30" ]] || [[ "$currenttime" < "06:00" ]]; then
            gsettings set $gnome_schema gtk-theme 'Materia-dark'
            gsettings set $gnome_schema icon-theme 'Papirus-Dark'
            gsettings set $gnome_schema cursor-theme 'capitaine-cursors'
            gsettings set $gnome_schema font-name 'Jost* 12'
            gsettings set $gnome_schema cursor-size 32
      else
        gsettings set $gnome_schema gtk-theme 'Materia-light'
            gsettings set $gnome_schema icon-theme 'Papirus-Light'
            gsettings set $gnome_schema cursor-theme 'capitaine-cursors-white'
            gsettings set $gnome_schema font-name 'Jost* 12'
            gsettings set $gnome_schema cursor-size 32
      fi
    '';
  };

in {
  imports = [ hyprland.nixosModules.default ];

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

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
      wayfire
      fish
    '';
  };
  security.polkit.enable = true;
  qt5.enable = true;
  qt5.style = "gtk2";
  qt5.platformTheme = "gtk2";
  environment.systemPackages = with pkgs; [
    swaybg
    capitaine-cursors
    clipman
    configure-gtk
    dbus-sway-environment
    firefox-wayland
    glib
    greetd.gtkgreet
    grim
    imv
    kanshi
    kitty
    mako
    materia-theme
    mpv
    papirus-icon-theme
    pavucontrol
    pcmanfm
    polkit
    polkit_gnome
    rofi-wayland
    slurp
    sway
    sway-polkit
    swayidle
    swaylock-effects
    thunderbird-wayland
    transmission-gtk
    waybar
    wayland
    wl-clipboard
    wlsunset
    xarchiver
    zathura
  ];
  fonts.fonts = with pkgs; [
    font-awesome
    jost
    nerdfonts
    noto-fonts-emoji
    source-han-mono
    source-han-sans
    source-sans
    fantasque-sans-mono
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
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
  };
}
