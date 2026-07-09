{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./apps
    ./fix-display.nix
  ];

  programs.gnome-shell = {
    enable = true;

    extensions = with pkgs.gnomeExtensions; [
      { package = inputs.albumwm.packages.${pkgs.stdenv.hostPlatform.system}.default; }
      { package = gsconnect; }
      { package = vitals; }
      { package = blur-my-shell; }
      { package = light-style; }
      { package = windownavigator; }
      { package = middle-click-to-close-in-overview; }
      { package = caffeine; }
      { package = appindicator; }
    ];
  };

  home.packages = with pkgs; [
    gjs
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      #color-scheme = "prefer-dark";
      show-battery-percentage = true;
      gtk-enable-primary-paste = true; # HOW DARED YOU
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "terminate:ctrl_alt_bksp"
      ];
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us+colemak"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "ru+rulemak"
        ])
      ];

      # Required for ru+rulemak to work at all
      show-all-sources = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;

      experimental-features = [
        "scale-monitor-framebuffer"
        "variable-refresh-rate"
        "xwayland-native-scaling"
        "autoclose-xwayland"
      ];
    };

    "org/gnome/shell" = {
      # For whatever reason, since GNOME 50 they've decided to hide it when
      # there's only one user.
      always-show-log-out = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      name = "Terminal";
      command = "ptyxis --new-window";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];

      screensaver = [ "<Control><Alt><Super>l" ];
      rotate-video-lock-static = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      dynamic-workspaces = false;
      num-workspaces = 10;

      # Focus follows mouse, but isn't lost when the mouse moves to empty space.
      focus-mode = "sloppy";

      # Not compatible with AlbumWM.
      edge-tiling = false;

      # WooP works bad with AlbumWM (but works).
      workspaces-only-on-primary = false;
    };

    "org/gnome/mutter/keybindings" = {
      # Not compatible with AlbumWM.
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    "org/gnome/shell/keybindings" = {
      # Super+{number} by default, which we need for workspaces.
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [
        "<Super>Home"
        "<Super>1"
      ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      switch-to-workspace-last = [ "<Super>End" ];

      switch-to-workspace-left = [
        "<Super>i"

        "<Super>Page_Up"
        "<Super>KP_Prior"
        "<Super><Alt>Left"
        "<Control><Alt>Left"
      ];
      switch-to-workspace-right = [
        "<Super>u"

        "<Super>Page_Down"
        "<Super>KP_Next"
        "<Super><Alt>Right"
        "<Control><Alt>Right"
      ];

      move-to-workspace-1 = [
        "<Super><Shift>Home"
        "<Super><Shift>1"
      ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
      move-to-workspace-last = [ "<Super><Shift>End" ];

      move-to-workspace-left = [
        "<Shift><Super>i"

        "<Super><Shift>Page_Up"
        "<Super><Shift>KP_Prior"
        "<Super><Shift><Alt>Left"
        "<Control><Shift><Alt>Left"
      ];
      move-to-workspace-right = [
        "<Shift><Super>u"

        "<Super><Shift>Page_Down"
        "<Super><Shift>KP_Next"
        "<Super><Shift><Alt>Right"
        "<Control><Shift><Alt>Right"
      ];

      minimize = [ "<Control><Alt><Super>h" ];

      # Replaced by AlbumWM's move-window-to-monitor-{left,below,above,right}.
      move-to-monitor-left = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-up = [ ];
      move-to-monitor-right = [ ];
    };

    "org/gnome/shell/extensions/albumwm" = {
    };

    "org/gnome/shell/extensions/albumwm/keybindings" = {
    };
  };
}
