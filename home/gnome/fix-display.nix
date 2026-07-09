{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeScriptBin "fix-display" (builtins.readFile ./fix-display.js))
  ];
}
