{ pkgs, inputs, ... }:
{
  imports = [
    ./firefox.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    gimp3
    libreoffice-fresh
    telegram-desktop

    # fonts
    font-awesome
    dejavu_fonts
    nerd-fonts.symbols-only
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
    };
  };

  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    platformTheme = {
      name = "xdgdesktopportal";
      package = with pkgs; [
        qadwaitadecorations
        qadwaitadecorations-qt6
      ];
    };
    style.name = "adwaita-dark";
  };

  # Imperative (for now) file synchronization
  services.syncthing = {
    enable = true;
  };
}
