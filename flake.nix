{
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/115a96e2ac1e92937cd47c30e073e16dcaaf6247"; # Apr 10, 2023 12:15 PM PDT (nixos-22.11)
    #nixpkgs.url = "github:NixOS/nixpkgs/0f7f5ca1cdec8dea85bb4fa60378258171d019ad"; # May 29, 2023 3:30am PDT (nixos-23.05)
    nixpkgs.url = "github:NixOS/nixpkgs/56911ef3403a9318b7621ce745f5452fb9ef6867"; # Jan 27, 2024 8:37am PS (nixos-23.11)

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        my-python-packages = ps: with ps; [
          boto3
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ansible
            (python3.withPackages my-python-packages)
          ];

          #shellHook = with pkgs; ''
          #  echo "packer `${packer}/bin/packer --version`"
          #  ${terraform}/bin/terraform --version
          #  ${nomad}/bin/nomad --version
          #  ${vault}/bin/vault --version
          #'';
        };
      }
    );
}
