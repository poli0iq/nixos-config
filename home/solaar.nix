{ lib, ... }:
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
}
