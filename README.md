# Showing issues with squashfs reproducibility in nix

To reproduce, clone this repository and run :
```
nix develop -i --command bash -c "nix run"
```

On my NixOS, I found :
```
efe26a17e679090b598167d53da3ab3630c5a2d4e092fc25928f31e28737996e
```

On my xubuntu, I found :
```
1960306f3d10bf282b6fc823098ff42e3633a24ca54d3bc4f27eb55c1e852156
```

