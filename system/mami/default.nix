{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # Use systemd-boot
    #loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Required to unlock LUKS with a key from TPM
    initrd.systemd.enable = true;

    # Lanzaboote currently replaces systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    kernelParams = [
      # Use xe
      #"i915.force_probe=!7d41"
      #"xe.force_probe=7d41"
    ];
  };

  hardware = {
    bluetooth.enable = true;

    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  services = {
    fprintd.enable = true;

    udev.extraRules = ''
      # Enable wakeup on bluetooth devices activity
      ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{power/wakeup}="enabled"
    '';
  };

  # Oh fuck
  programs.evolution = {
    enable = true;

    plugins = [ pkgs.evolution-ews ];
  };

  # Work vpn
  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];
}
