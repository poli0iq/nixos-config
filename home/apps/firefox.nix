{ pkgs, inputs, ... }:
{
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  programs.firefox = {
    enable = true;

    #settings = {
    #  "privacy.resistFingerprinting" = false;
    #  "privacy.fingerprintingProtection" = false;
    #  "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
    #};

    profiles.default = {
      isDefault = true;

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        gsconnect
        gnome-shell-integration
        kagi-search
      ];

      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
      extraConfig = ''
        ${builtins.readFile "${inputs.firefox-gnome-theme}/configuration/user.js"}
        ${builtins.readFile "${inputs.betterfox}/user.js"}
      '';

      search = {
        force = true;
        default = "Kagi";
        privateDefault = "DuckDuckGo";
        order = [
          "Kagi"
          "Google"
          "DuckDuckGo"
        ];
        engines = {
          Google = {
            urls = [
              {
                template = "https://www.google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            iconUpdateURL = "https://www.google.com/favicon.ico";
            definedAliases = [
              "@google"
              "@g"
            ];
          };

          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "NixOS Wiki" = {
            urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
        };
      };
    };
  };
}
