{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "space_age_api";
        src = ./.;
        version = "1.0.0";

        mixFodDeps = pkgs.beamPackages.fetchMixDeps ({
          inherit src version;
          pname = "mix-deps-${pname}";
          hash = builtins.readFile ./deps-hash.txt;
        });

        package = pkgs.beamPackages.mixRelease ({
          inherit src pname mixFodDeps version;
        });
      in
      {
        packages = {
          default = package;
          ${pname} = package;
        };
      });
}
