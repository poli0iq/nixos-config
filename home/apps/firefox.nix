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

        # Bring back search autosuggestions that are disabled by betterfox
        user_pref("browser.search.suggest.enabled", true);
        user_pref("browser.urlbar.quicksuggest.enabled", true);
      '';

      search = {
        force = true;
        default = "kagi";
        privateDefault = "duckduckgo";
        order = [
          "kagi"
          "google"
          "duckduckgo"
        ];
        engines = {
          kagi = {
            urls = [
              {
                template = "https://kagi.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
              {
                # Suggestions URL
                type = "application/x-suggestions+json";
                template = "https://kagi.com/api/autosuggest";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            name = "Kagi";
            icon = "https://kagi.com/favicon.ico";
            definedAliases = [
              "@kagi"
              "@k"
            ];
          };

          google = {
            # Builtin engines only support specifying one additional alias
            metaData.alias = "@g";
          };

          nix-packages = {
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

            name = "Nix Packages";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-options = {
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

            name = "NixOS Options";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          nixos-wiki = {
            urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];

            name = "NixOS Wiki";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };

          # Disable bullshit
          bing.metaData.hidden = true;
        };
      };
    };
  };
}
