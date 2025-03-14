{
  description = "Hashicorp vault server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        apps.default =
          let
            script = pkgs.writeShellScriptBin "create-non-reproducible-squashfs"
              ''
                FILE=$(mktemp -u -t non-reproducible-XXX.squashfs)
                # options for squashfs are copied from https://github.com/NixOS/nixpkgs/blob/845dc1e9cbc2e48640b8968af58b4a19db67aa8f/nixos/lib/make-squashfs.nix#L52
                ${pkgs.squashfsTools}/bin/mksquashfs ${pkgs.aws-c-common} $FILE -no-hardlinks -keep-as-directory -all-root -b 1048576 -comp gzip -Xcompression-level 1 -processors 1 -root-mode 0755 -no-compression > /dev/null
                ${pkgs.coreutils}/bin/sha256sum $FILE
              '';
          in
          {
            type = "app";
            # options for squashfs are copied from https://github.com/NixOS/nixpkgs/blob/845dc1e9cbc2e48640b8968af58b4a19db67aa8f/nixos/lib/make-squashfs.nix#L52
            program = "${pkgs.lib.getExe script}";
          };
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.nix ];
          };
      }));
}
