let
  poli-sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGZKFPQNRf1H/4k0wjCMiATRBQ1BoEYPSFX6EhGInWw poli@sayaka";
  poli-homura = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNOTz1K4rWBIMQ/FjWY6/CgUm/doRKs9w6MB2khUtnm poli@homura";
  poli-madoka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1uUmneJb2GH7+NsZfjMz2tmoo1aBaXzuuwKLeewCJG poli@madoka";
  users = [
    poli-sayaka
    poli-homura
    poli-madoka
  ];

  sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFarrIP0OqMflQwktGYk084TzztWipdWtgMTPv5+cIR";
  homura = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDahvpA63/mTdyJUjqSKuuTkDLjvnR6MihzwOeDT46i+";
  madoka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGPHN0Ym3LKRKWvSmu2ZihikYyuOZW1/s1k8qTWQIdY";

  systems = [
    sayaka
    homura
    madoka
  ];
in
{
  "singbox_uuid.age".publicKeys = users ++ systems;
}
