{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pname = "space_age_api";
        src = ./.;
        version = "1.0.0";

        mixFodDeps = pkgs.beamPackages.fetchMixDeps ({
          inherit src version;
          pname = "mix-deps-${pname}";
          hash = "sha256-iyfxW0e6fPU1Wq+sLNTC5MPg3V1nUmeoghMI+2gHwoY=";
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
