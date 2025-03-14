FROM nixos/nix

RUN <<EOR
cat << EOF > /etc/nix/nix.conf
build-users-group = nixbld
sandbox = true
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
experimental-features = nix-command flakes
EOF
EOR
