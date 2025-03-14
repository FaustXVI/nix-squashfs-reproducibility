# Showing issues with squashfs reproducibility in nix

To reproduce, clone this repository and run :
```
nix develop -i --command bash -c "nix run"
```

On my NixOS, I found :
```
1960306f3d10bf282b6fc823098ff42e3633a24ca54d3bc4f27eb55c1e852156
```

On my xubuntu, I found :
```
```

