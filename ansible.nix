{ nixpkgs}:
let
  # Create a wrapper of terraform that has access to only the declared list of
  # providers. Mixed-and-matched from both nixpkgs and this project.
  my_python = nixpkgs.terraform.withPlugins (p: [
    # The providers coming from nixpkgs have a flat namespace
    # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/applications/networking/cluster/terraform-providers/providers.json
    p.aws
    p.null

    # for transfer_family module
    #p.local
    #p.archive

    # for terrablocks sftp module
    p.random

    # dns made easy 
    p.dme

    # The providers coming from nixpkgs-terraform-providers-bin have a 1:1
    # mapping with the terraform registry, replacing `/` with `.`:
    # https://registry.terraform.io/providers/hashicorp/nomad
    nixpkgs-terraform-providers-bin.providers.hashicorp.nomad
  ]);
in
# Here we create a trivial shell with only that wrapper
nixpkgs.mkShell {
  packages = [
    my_terraform
  ];
}
