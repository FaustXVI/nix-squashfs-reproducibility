# Showing issues with squashfs reproducibility in nix

To reproduce, clone this repository and run :
```
nix build .#iso
```

Then compute the `sha256sum` of the result with :
```
sha256sum result/iso/nixos.iso
```

On my NixOS, I found :
```
9c09867b3e073243aa8020630ae488b639f289b17dc7d68c859a8c160ba1b16b
```

On my xubuntu, I found :
```
05355dc48302cfdec8f8eb70ceadbc5edf2042724208b481463611ac280a72d1
```

