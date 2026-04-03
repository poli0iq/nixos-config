{ pkgs, inputs, ... }:
{
  imports = [
    ./firefox.nix
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

  programs.mangohud = {
    enable = true;
    settings = {
      gpu_status = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;

      cpu_status = true;
      cpu_temp = true;
      cpu_mhz = true;
      cpu_power = true;

      ram = true;
      vram = true;

      fps = true;
      frametime = true;

      throttling_status = true;

      text_outline = true;

      gpu_name = true;
      vulkan_driver = true;
      wine = true;
      winesync = true;
      present_mode = true;
      gamemode = true;

      frame_timing = true;

      font_scale = 1.5;
      font_file = "${pkgs.adwaita-fonts}/share/fonts/Adwaita/AdwaitaMono-Bold.ttf";
    };
  };
}
