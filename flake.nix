{
  description = "quant-trading";

  inputs = {
    nixpkgs.url     = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    let
      supportedSystems = [ "x86_64-linux" ];

    in flake-utils.lib.eachSystem supportedSystems (system:

      let
        pkgs = import nixpkgs { inherit system; };

        python = pkgs.python3;

        quant-trading = pkgs.python3Packages.buildPythonPackage {

          name = "quant-trading";

          src = ./.;

          propagatedBuildInputs = with pkgs; with python.pkgs; [
            ipykernel matplotlib numpy pandas statsmodels yfinance
          ];

          format = "other";

          installPhase = ''
            mkdir -p $out
          '';

          doBuild = false;
        };

      in {

        packages = {

          inherit quant-trading;

          default = quant-trading;
        };

        devShells = {

          default = pkgs.mkShellNoCC {

            packages = with pkgs; [
              quant-trading
            ];

            shellHook = "export PS1='\\e[1;34mdev > \\e[0m'";
          };
        };
      });
}
