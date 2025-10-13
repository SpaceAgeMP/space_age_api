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

        envVars = {
          DATABASE_URL = "ecto://space_age_api@127.0.0.1/space_age_api";
          SECRET_KEY_BASE = "changeme";
          SENTRY_DSN_SRCDS = "";
          SENTRY_DSN_API = "";
        };

        mixFodDeps = pkgs.beamPackages.fetchMixDeps ({
          inherit src version;
          pname = "mix-deps-${pname}";
          hash = "sha256-eTyDUQdxPWiE/RkhcPYGhXNHRVknMNxpuruHahTTXyo=";
        } // envVars);

        package = pkgs.beamPackages.mixRelease ({
          inherit src pname mixFodDeps version;
        } // envVars);
      in
      {
        packages = {
          default = package;
          ${pname} = package;
        };
      });
}
