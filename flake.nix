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
          hash = "sha256-aq1eKaJf/T4LWj9j+Lq6thM9qbCL5O5+6OXOAzPdL2w=";
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
