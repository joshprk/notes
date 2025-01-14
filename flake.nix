{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;

    getPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells = forAllSystems (system: let
      pkgs = getPkgs system;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (python3.withPackages (p: with p; [
            numpy
          ]))
        ];
      };
    });
  };
}
