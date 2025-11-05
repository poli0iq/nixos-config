{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./secrets.nix
    ./sing-box.nix
  ];

  nix = {
    # make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      # Allow wheel group to use substituters
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking = {
    # Pick only one of the below networking options.
    # wireless.enable = true;
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    firewall.enable = false;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.graphics.enable = true;

  # Controller support
  hardware.steam-hardware.enable = true;

  # Enable sound.
  # No real need to save the state on reboot
  #sound.enable = true;
  services.pulseaudio.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.poli = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "adbusers"
      "wireshark"
      "docker"
      "dialout"
    ];
    shell = pkgs.fish;
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };

    fwupd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    flatpak.enable = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.defaultPackages = [ ];

  environment.systemPackages =
    with pkgs;
    [
      # system
      linuxPackages_latest.cpupower
      glib # gsettings
      man-pages
      man-pages-posix
      sbctl # secure boot keys
      wayland

      # cli
      htop
      wget
      tmux
      inetutils
      dig
      pciutils
      usbutils
      git
      neovim

      # for virtiofs in virt-manager
      virtiofsd
    ]
    ++ (with hunspellDicts; [
      # Dictionaries have to be installed manually for now
      en_US
      ru_RU
      pl_PL
    ]);

  # xdg-desktop-portal (screen sharhing, file choosing, etc.)
  #xdg.portal = {
  #  enable = true;

  #  wlr.enable = true;
  #  configPackages = with pkgs; [
  #    xdg-desktop-portal-wlr
  #  ];

  #  # gtk portal needed to make gtk apps happy
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-gtk
  #    xdg-desktop-portal-kde
  #  ];
  #};

  security = {
    polkit.enable = true;

    sudo.enable = true;

    # Needed for PipeWire
    rtkit.enable = true;
  };

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;

    fish.enable = true;

    dconf.enable = true;

    adb.enable = true;

    wireshark.enable = true;

    virt-manager.enable = true;
  };

  virtualisation = {
    podman.enable = true;

    libvirtd = {
      enable = true;
    };
  };

  # Allow root to edit hosts directly (will reset after system rebuild)
  environment.etc.hosts.mode = "0644";

  # Enable ucode updates
  hardware.enableRedistributableFirmware = true;

  services.displayManager.gdm = {
    enable = true;
    banner = "you're cute!!! ><";
  };

  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    # Old video player, will be replaced with showtime in GNOME 49
    totem

    # Old pdf viewer, I use papers instead
    evince

    # Old terminal, I use Ptyxis
    gnome-console
  ];

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Useful for steam etc.
  hardware.graphics.enable32Bit = true;

  # Fancy boot splash screen
  boot.plymouth.enable = true;
}
