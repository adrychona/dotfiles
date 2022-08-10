{ config, pkgs, fetchurl, ... }:

let
  extrahostsfromsteve = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/StevenBlack/hosts/v2.3.7/alternates/fakenews-gambling-porn/hosts";
    sha256 = "sha256-Yh5txZZQQFpXd21pYYOBLIWlG+ql5/Sf8zNbx3wrne4=";
  };
in { networking.extraHosts = "${builtins.readFile extrahostsfromsteve} "; }
