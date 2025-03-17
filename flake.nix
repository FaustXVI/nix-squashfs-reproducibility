{
  description = "Hashicorp vault server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-aws.url = "github:NixOS/nixpkgs/3f0a8ac25fb674611b98089ca3a5dd6480175751";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-aws, ... }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgs-aws = import nixpkgs-aws { inherit system; };
      in
      {
        apps = {
          default =
            let
              script = pkgs.writeShellScriptBin "create-non-reproducible-squashfs"
                ''
                  set -x
                  FILE=$(mktemp -u -t non-reproducible-XXX.squashfs)
                  # options for squashfs are copied from https://github.com/NixOS/nixpkgs/blob/845dc1e9cbc2e48640b8968af58b4a19db67aa8f/nixos/lib/make-squashfs.nix#L52
                  ${pkgs.squashfsTools}/bin/mksquashfs ${pkgs-aws.aws-c-common} $FILE -no-hardlinks -keep-as-directory -all-root -b 1048576 -comp gzip -Xcompression-level 1 -processors 1 -root-mode 0755 -no-compression > /dev/null
                  ${pkgs.coreutils}/bin/sha256sum $FILE
                '';
            in
            {
              type = "app";
              program = "${pkgs.lib.getExe script}";
            };
          vm =
            let
              xubuntu = pkgs.fetchurl {
                url = "http://ftp.free.fr/mirrors/ftp.xubuntu.com/releases/24.04/release/xubuntu-24.04.2-minimal-amd64.iso";
                hash = "sha256-7TSyEyltXgLOtOwZzcIc5QI7j00JmqGLh2Rox8sdQbo=";
              };
              testScript = pkgs.writeShellScriptBin "test-iso" ''
                ${pkgs.qemu}/bin/qemu-system-x86_64 -bios ${pkgs.OVMF.fd}/FV/OVMF.fd -enable-kvm -m 4G -cdrom ${xubuntu} -virtfs local,path=.,mount_tag=shared,security_model=mapped-xattr "$@"
              '';
            in
            {
              type = "app";
              program = "${pkgs.lib.getExe testScript}";
            };
        };
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.nix ];
        };
      }));
}
