{ pkgs, lib, ... }:
let
  mkSolaarKeybinding =
    key: action:
    lib.generators.toYAML { } [
      {
        Key = [
          key
          "pressed"
        ];
      }
      {
        KeyPress = [
          action
          "click"
        ];
      }
    ];

  concatYamlDocuments = documents: builtins.concatStringsSep "\n---\n" documents;
in
{
  xdg.configFile."solaar/rules.yaml".text = concatYamlDocuments [
    (mkSolaarKeybinding "Screen Capture" "Print")
    (mkSolaarKeybinding "Mute Microphone" "XF86_AudioMicMute")
  ];

  systemd.user.services.solaar = {
    Unit = {
      Description = "Logitech device settings manager";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.solaar}/bin/solaar --window hide";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
