{ config, lib, pkgs, ... }:

{
  services.emacs = {
    package = pkgs.emacsPgtkGcc;
    install = true;
    defaultEditor = true;
    enable = true;
  };

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "bfc8f6edcb7bcf3cf24e4a7199b3f6fed96aaecf"; # change the revision
    }))
  ];

  environment.systemPackages = with pkgs; [ emacsPgtkGcc ];
}
