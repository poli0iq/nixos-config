{ pkgs, inputs, ... }:
{
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = with pkgs; [
        gnomeExtensions.gsconnect
        gnome-browser-connector
      ];
    };

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
                template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }
            ];

            name = "Nix Packages";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-options = {
            urls = [
              {
                template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              }
            ];

            name = "NixOS Options";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          home-manager-options = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/?release=master";
                type = "searchform";
              }
              {
                template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
              }
            ];

            name = "Home Manager Options";
            icon = "https://home-manager-options.extranix.com/images/favicon.png";
            definedAliases = [
              "@homemanager"
              "@hm"
            ];
          };

          nixos-wiki = {
            urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];

            name = "NixOS Wiki";
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };

          wiktionary-en = {
            urls = [
              {
                template = "https://en.wiktionary.org/wiki/Special:Search";
                type = "searchform";
              }
              {
                template = "https://en.wiktionary.org/w/index.php?title=Special:Search&search={searchTerms}";
              }
              {
                template = "https://en.wiktionary.org/w/api.php?action=opensearch&search={searchTerms}&namespace=0";
                type = "application/x-suggestions+json";
              }
              {
                template = "https://en.wiktionary.org/w/api.php?action=opensearch&format=xml&search={searchTerms}&namespace=0";
                type = "application/x-suggestions+xml";
              }
            ];

            name = "Wiktionary (en)";
            icon = "https://en.wiktionary.org/favicon.ico";
            definedAliases = [
              "@wiktionary"
              "@wt"
            ];
          };

          # Disable bullshit
          bing.metaData.hidden = true;
          perplexity.metaData.hidden = true;
        };
      };
    };
  };
}
