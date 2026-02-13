# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Needed to unlock LUKS with key from TPM
  boot.initrd.systemd.enable = true;

  services.fprintd.enable = true;
  hardware.bluetooth.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-ocl
    intel-compute-runtime
    vpl-gpu-rt
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Use xe
  boot.kernelParams = [
    #"i915.force_probe=!7d41"
    #"xe.force_probe=7d41"
  ];

  services.udev.extraRules = ''
    # Enable wakeup on bluetooth devices activity
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{power/wakeup}="enabled"
  '';

  # Oh fuck
  programs.evolution = {
    enable = true;

    plugins = [ pkgs.evolution-ews ];
  };

  # Work vpn
  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];
}
