{
  description = "Qubit: Python env with IQM, Qiskit and D-Wave";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.python312
            pkgs.uv
            pkgs.git
          ];

          env = {
            UV_PYTHON_DOWNLOADS = "never";
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
            # PyPI wheels (qiskit-aer, numpy, ...) expect FHS libs
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.zlib
            ];
          };

          shellHook = ''
            [ -d .venv ] || uv venv --quiet --python ${pkgs.python312}/bin/python3.12 .venv
            source .venv/bin/activate
            stamp=.venv/.requirements.sha256
            hash=$(sha256sum requirements.txt | cut -d' ' -f1)
            if [ "$(cat "$stamp" 2>/dev/null)" != "$hash" ]; then
              uv pip install -r requirements.txt && echo "$hash" > "$stamp"
            fi
          '';
        };
      });
    };
}
