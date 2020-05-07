# mobian-recipes

A set of [debos](https://github.com/go-debos/debos) recipes for building a
debian-based image for mobile phones, initially targetting Pine64's PinePhone.

Prebuilt images are available [here](http://images.mobian-project.org/).

The default user is `debian` with password `1234`.
The default `root` password is `root`.

## Build

To build the image, you need to have `debos` and `bmaptool`. On a debian-based
system, install these dependencies by typing the following command in a terminal:

```
sudo apt install debos bmap-tools
```

If your system isn't debian-based (or if you choose to install `debos` without
using `apt`, which is a terrible idea), please make sure you also install the
following required packages:
- `debootstrap`
- `qemu-system-x86`
- `qemu-user-static`
- `binfmt-support`

Then simply browse to the `mobian-recipes` folder and execute `./build.sh`.

You can use `./build.sh -d` to use the docker version of `debos`.

## Install

Insert a MicroSD card into your computer, and type the following command:

```
sudo bmaptool copy <image> /dev/<sdcard>
```

or:

```
sudo dd if=<image> of=/dev/<sdcard> bs=1M
```

*Note: Make sure to use your actual SD card device, such as `mmcblk0` instead of
`<sdcard>`.*

**CAUTION: This will format the SD card and erase all its contents!!!**

## Third-party software

The project's Wiki provides
[a list](https://gitlab.com/mobian1/wiki/-/wikis/Software) of software
packages modified or created to work on mobile devices.

## Contributing

If you want to help with this project, please have a look at the
[roadmap](https://gitlab.com/mobian1/wiki/-/wikis/Development-Roadmap) and
[open issues](https://gitlab.com/mobian1/issues).

In case you need more information, feel free to get in touch with the developers
on the Pine64 [forum](https://forum.pine64.org/showthread.php?tid=9016) and/or
[#mobian:matrix.org](https://matrix.to/#/#mobian:matrix.org).

# License

This software is licensed under the terms of the GNU General Public License,
version 3.
