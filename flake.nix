{
  description = "Hashicorp vault server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    {
      iso = (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
          { system.stateVersion = "24.11"; }
        ];
      }).config.system.build.isoImage;
    };
}
