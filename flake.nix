{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      lanzaboote,
      nvf,
      agenix,
      nix-index-database,
      nur,
      ...
    }@inputs:
    {
      nixosConfigurations =
        let
          makeNixosConfiguration =
            name: modules:
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                (
                  { ... }:
                  {
                    networking.hostName = name;
                  }
                )

                ./system
              ] ++ modules;
            };
        in
        {
          fallback = makeNixosConfiguration "fallback-hostname" [ ];

          madoka = makeNixosConfiguration "madoka" [
            ./system/madoka
            lanzaboote.nixosModules.lanzaboote
            agenix.nixosModules.age
          ];

          sayaka = makeNixosConfiguration "sayaka" [
            ./system/sayaka
            lanzaboote.nixosModules.lanzaboote
            agenix.nixosModules.age
          ];

          homura = makeNixosConfiguration "homura" [
            ./system/homura
            lanzaboote.nixosModules.lanzaboote
            agenix.nixosModules.age
          ];
        };

      homeConfigurations =
        let
          makeHomeConfiguration =
            modules:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              extraSpecialArgs = { inherit inputs; };
              modules = [
                ./home
                ./home/gnome
                nvf.homeManagerModules.default
                nix-index-database.homeModules.nix-index
                nur.modules.homeManager.default
              ] ++ modules;
            };
        in
        {
          "poli" = makeHomeConfiguration [ ];

          "poli@madoka" = makeHomeConfiguration [ ];

          "poli@sayaka" = makeHomeConfiguration [ ];

          "poli@homura" = makeHomeConfiguration [ ];
        };
    };
}
