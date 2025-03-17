# Showing issues with squashfs reproducibility in nix

## TL;DR

To reproduce, clone this repository and run :
```
nix develop -i --command bash -c "nix run"
```

On my NixOS, I found :
```
efe26a17e679090b598167d53da3ab3630c5a2d4e092fc25928f31e28737996e
```

On my Xubuntu, I found something like :
```
1960306f3d10bf282b6fc823098ff42e3633a24ca54d3bc4f27eb55c1e852156
```

An interesting fact is that, on NixOS, I always reproduce the same squashfs
but on Xubuntu it seems stable at first but changes from time to time for reasons I have yet to understand.

The exemple was given on Xubuntu, but the same happens on Ubuntu.

You may not reproduce it because I have seen some (most?) Ubuntu comptuers having the same result than my NixOS.

## A little bit of history

The issue was discovered while trying to reproduce an custom iso for work.

The original idea (simplified) can be found in the branch `iso`.

While trying to understand the issue, we realize that the only difference was in the `squashfs` file and, in that file, the only thing that changes seems to be the number of bytes declared in the `squashfs` format and the padding that comes with it.

We thus focused on `squashfs`.

This repository explains what we found.

## Reproducing

You can run a xubuntu «live-cd» vm with :
```
nix run .#vm.xubuntu
```

Change the keyboard layout as you wish in `setting > keyboard > layout` and then mount this folder with :
```
sudo mount -t 9p shared /mnt
```

Go to `/mnt` and run
```
./vm/install-nix.sh
```

Close the terminal, open a new one and go back to `/mnt`.

You are ready to reproduce the non-reproducibility with :
```
nix develop -i --command bash -c "nix run"
```

Interestingly new vms always produce the same result :
```
3ebddc49fb5e4ac37af6b182ce3e68e143e285455a9d8f08c1a7001cb8f314bb
```

You can also do the same steps in a ubuntu with :
```
nix run .#vm.ubuntu
```
This will give the same result as the xubuntu.

## Workaround

Finally, on a computer that doesn't reproduce the correct `squashfs`, you can work around the problem by running nix in docker in sandbox mode as described in https://hub.docker.com/r/nixos/nix and demonstrated in the `docker` branch if you run the command :

```
docker build --tag 'mynix' . && docker run -v .:/mnt --privileged --rm -ti mynix bash -c 'cd /root && cp /mnt/flake.* . && nix develop -i --command bash -c "nix run"'
```


