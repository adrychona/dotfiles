{ config, pkgs, ... }: {
  environment.localBinInPath = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_DATA_HOME = "$HOME/.local/share";

    XDG_STATE_HOME = "$HOME/.local/state";
    PATH = [ "$XDG_BIN_HOME" "$XDG_CONFIG_HOME/emacs/bin" ];
  };
  environment.variables = {
    GTK2_RC_FILES =
      "${config.environment.sessionVariables.XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
    HISTFILE =
      "${config.environment.sessionVariables.XDG_STATE_HOME}/bash/history";

    "DSSI_PATH" =
      "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    "LADSPA_PATH" =
      "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    "LV2_PATH" =
      "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    "LXVST_PATH" =
      "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    "VST_PATH" =
      "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
    "VST3_PATH" =
      "$HOME/.vst3:$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3";
    "RANGER_LOAD_DEFAULT_RC" = "false";
    "OCL_ICD_VENDORS" =
      " `nix-build '<nixpkgs>' --no-out-link -A rocm-opencl-icd`/etc/OpenCL/vendors/";

  };
}
