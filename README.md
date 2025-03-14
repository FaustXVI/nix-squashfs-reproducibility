# Showing issues with squashfs reproducibility in nix

To reproduce, clone this repository and run :
```
nix develop -i --command bash -c "nix run"
```

On my NixOS, I found :
```
efe26a17e679090b598167d53da3ab3630c5a2d4e092fc25928f31e28737996e
```

On my Xubuntu, I found something like* :
```
1960306f3d10bf282b6fc823098ff42e3633a24ca54d3bc4f27eb55c1e852156
```

*An interesting fact is that, on NixOS, I always reproduce the same squashfs
but on Xubuntu it varies.

The exemple was given on Xubuntu, but the same happens on Ubuntu.
You may not reproduce it because I have seen some (most?) Ubuntu comptuers having the same result than my NixOS.

Another interesting fact is that if I copy the aws files checked out by nix in a folder and use squashfs on that folder instead, then I always have the same restult regardless of the OS :
```
4de3f240c1605b0903483a3397a744f5ce91768ebb9214cff5cb3ba64380536b
```

This can be reproduced on the branch `copy-aws`

However, dynamically copying the files doesn't solve the issue as demonstrated by the branch `dynamic-copy-aws`

So it seems that, because we added the files to git, the problem got solved.

Finally, on a computer that doesn't reproduce the correct `squashfs`, you can work around the problem by running nix in docker in sandbox mode as described in https://hub.docker.com/r/nixos/nix and demonstrated in the `docker` branch if you run the command :

```
docker build --tag 'mynix' . && docker
 run -v .:/mnt --privileged --rm -ti mynix bash -c 'cd /root && cp /mnt/flake.* . && nix develop -i --command bash -c "nix run"'
```


