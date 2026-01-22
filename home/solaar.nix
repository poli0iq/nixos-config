{ pkgs, ... }:
{
  xdg.configFile."solaar/rules.yaml".text = builtins.concatStringsSep "\n---\n" [
    (pkgs.lib.generators.toYAML { } [
      {
        Key = [
          "Screen Capture"
          "pressed"
        ];
      }
      {
        KeyPress = [
          "Print"
          "click"
        ];
      }
    ])
    (pkgs.lib.generators.toYAML { } [
      {
        Key = [
          "Mute Microphone"
          "pressed"
        ];
      }
      {
        KeyPress = [
          "XF86_AudioMicMute"
          "click"
        ];
      }
    ])
  ];
}
