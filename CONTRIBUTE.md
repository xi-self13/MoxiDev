# Contributions

## How do I contribute?

Well you can start by reviewing vulnerabilities as in securtiy, viruses, and other unwanted codes. You can then start a issue and we will get to you!

### If I Want To Code, What's Required?

I'd normally use NixOS. But for debian, ubuntu, and NixOS. You'd need the following:

NixOS - :
```nix
{ pkgs, ... }: {
    ...
    packages = {
        pkgs.python3
        pkgs.clang
        pkgs.cmake
        pkgs.gnumake
        pkgs.git # if you is not using Firebase Studio's NixOS
        # that's all for now
    }
    ...
}
```
Debian/Ubuntu: 

For CLang and Make use this: 
```sh
sudo apt update && sudo apt upgrade && sudo apt install clang build-essential
```
For Cmake. You may try and use:
```sh
sudo apt update
sudo apt install cmake
```
if that don't work. Try downloading it from debian's official website. Ubuntu may do this too.

[Cmake On Debian Amd64](https://packages.debian.org/sid/amd64/cmake/download)

As for python. It should be preinstalled. if not. Do this: 
`sudo apt install python3`

Make sure to have git installed. You can do this `sudo apt install git`

That should be it via packages.
### Recommended Apps
**Firebase Studio, or VSCode**

Your device should also be:
- 3G of RAM.
- 20G of storage at least.

That's all for now.