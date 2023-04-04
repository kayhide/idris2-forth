{
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    idris2-nix = {
      url = "github:kayhide/idris2-nix";
    };
  };

  outputs = { self, nixpkgs, flake-utils, idris2-nix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ idris2-nix.overlay ]; };

          inherit (pkgs) lib;

        in
        {
          devShell =
            let
              idris2 = idris2-nix.packages."${system}".idris2;

              deps = with idris2-nix.packages."${system}"; [
                pretty-show
                elab-util
                sop
                hedgehog
              ];

            in
            pkgs.mkShell {
              buildInputs = with pkgs; [
                rlwrap
                gnumake
                idris2
              ] ++ deps;

              IDRIS2_PACKAGE_PATH = lib.buildIdris2PackagePath deps;
            };
        }
      );
}
