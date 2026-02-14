{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
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
    networkmanager.enable = true;

    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    firewall.enable = false;
  };

  #time.timeZone = "Europe/Moscow";

  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    keyMap = "colemak";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Configure keymap (in my case primarily for GDM)
  services.xserver.xkb.layout = "us+colemak";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.graphics.enable = true;

  # Controller support
  hardware.steam-hardware.enable = true;

  # Solaar
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

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

  services = {
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

      # Needed for gsconnect extension
      nautilus-python
    ]
    ++ (with hunspellDicts; [
      # Dictionaries have to be installed manually for now
      en_US
      ru_RU
      pl_PL
    ]);

  security = {
    polkit.enable = true;

    sudo.enable = true;

    # Needed for PipeWire
    rtkit.enable = true;
  };

  programs = {
    fish.enable = true;

    dconf.enable = true;

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
    # Old terminal, I use Ptyxis
    gnome-console
    # Very old (gtk3), replacement: Field Monitor
    gnome-connections
  ];

  environment.defaultPackages = with pkgs; [
    # Better terminal for gnome
    ptyxis
    # For desktop files
    xdg-terminal-exec
    # Spice/VNC/RDP client
    field-monitor
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Useful for steam etc.
  hardware.graphics.enable32Bit = true;

  # Fancy boot splash screen
  boot.plymouth.enable = true;
}
