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
  };

  hardware = {
    bluetooth.enable = true;

    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      intel-compute-runtime
      vpl-gpu-rt
    ];

    # alsa-ucm-conf lacks DRC setup in EnableSequence,
    # so it's disabled by default.
    # It's present in BootSequence though,
    # so they essentially assume we preserve the state
    alsa.enablePersistence = true;
  };

  services = {
    fprintd.enable = true;

    udev.extraRules = ''
      # Enable wakeup on bluetooth devices activity
      ACTION=="bind", SUBSYSTEM=="pci", DRIVER=="btintel_pcie", ATTR{power/wakeup}="enabled"
    '';
  };

}
