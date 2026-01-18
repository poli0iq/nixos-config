{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # CalDAV-compatible personal task manager.
    # There are also errands and endeavour,
    # but the first one is undergoing a C rewrite (wtf),
    # and the second one is only recently active again,
    # 3 years since the last release
    planify
    # News reader
    newsflash
    # Torrent client
    fragments
    # Translation app
    dialect
    # Notes app with Nextcloud Notes sync
    iotas
    # Matrix client
    fractal
    # Screenshot editor
    gradia
    # Pomodoro timer
    gnome-solanum
    # Email client (I wish there was a better one)
    geary
  ];

  # TODO: remove once upgraded upstream
  nixpkgs.overlays = [
    (final: prev: {
      geary = prev.geary.overrideAttrs (old: {
        version = "0-unstable-2025-12-15";

        src = pkgs.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "GNOME";
          repo = "geary";
          rev = "be3ed978e2ad77c1197ccb5a6e887ffaeec12057";
          hash = "sha256-6iOv+DOxfWVojXrsH4tV3yL9GUTVvWFOp2SErcWhtW8=";
        };

        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.cmake ];

        buildInputs =
          (lib.lists.subtractLists (with pkgs; [
            gcr
            gtk3
            webkitgtk_4_1
          ]) old.buildInputs)
          ++ (with pkgs; [
            gtk4
            webkitgtk_6_0
            gcr_4
            libspelling
            libadwaita
            libpeas2
          ]);

        postPatch = lib.replaceString ''
          substituteInPlace meson.build \
            --replace-fail "appstream_glib = dependency('appstream-glib', version: '>=0.7.10')" ""
        '' "" old.postPatch;
      });
    })
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      #"text/html" = "org.gnome.Epiphany.desktop";
      #"x-scheme-handler/http" = "org.gnome.Epiphany.desktop";
      #"x-scheme-handler/https" = "org.gnome.Epiphany.desktop";
      "x-scheme-handler/mailto" = "org.gnome.Geary.desktop";
    };
  };

  dconf.settings = {
    # GNOME Web
    "org/gnome/epiphany" = {
      search-engine-providers =
        let
          mkDictionaryEntry = lib.hm.gvariant.mkDictionaryEntry;
          mkVariant = lib.hm.gvariant.mkVariant;
        in
        [
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://duckduckgo.com/?q=%s&t=epiphany")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!ddg")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "DuckDuckGo")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://kagi.com/search?q=%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!k")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "Kagi")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://www.google.com/search?q=%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!g")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "Google")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://context.reverso.net/translation/english-russian/%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!rc")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "ReversoContext")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://search.nixos.org/packages?query=%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!nixos-packages")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "NixOS Packages")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://search.nixos.org/options?query=%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!nixos-options")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "NixOS Options")
            ])
          ]
          [
            (mkDictionaryEntry [
              "url"
              (mkVariant "https://repology.org/projects/?search=%s")
            ])
            (mkDictionaryEntry [
              "bang"
              (mkVariant "!repology")
            ])
            (mkDictionaryEntry [
              "name"
              (mkVariant "Repology")
            ])
          ]
        ];

      default-search-engine = "Kagi";
    };
  };
}
