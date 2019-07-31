# file-watchdog

A simple `[systemd][systemd]`-friendly daemon that monitors the existance of a
file and executes scripts when it appears/disappears.

[systemd]: https://www.freedesktop.org/wiki/Software/systemd/

## Instructions

### How build use this software

To compile this software, execute `make` in the folder. Please do not attempt
build this tool out of tree, as it wil break the makefile. This process can be
faster if you parallelize the process by adding `-j` followed by the core count
of your system, just make sure your system have enough free memory to hold the
multiple instances of GCC, and some fast storage to keep the processors fed.

There is nothing to configure before building. Since all it relies on is a UNIX
compatible standard C library and a kernel that supports `poll(2)`. If it fails
you are likely using an incompatible OS.

### How to install and uninstall this software

To install this software after a success build, issue `make install` with root
privileges. This will install the binary to `/usr/sbin`, install the `systemd`
unit file to `/lib/systemd/system` and install an example configuration file in
`/etc/file-watchdog`. The root privileges is used to copy files to those places
and force systemd to load the installed unit file.

If you want to uninstall, run `make uninstall` with root privileges. This will
remove the binary and systemd unit file, however configuration files remains.
It is up to you to stop all instances of `file-watchdog` before uninstalling.
You don't need to build the software before uninstalling, so a lone `Makefile`
from the correct version of this tool can serve as the uninstaller.

If you want to uninstall and delete configuration files, run `make purge` with
root privileges. This will do everything `make uninstall` does, and remove
`/etc/file-watchdog`. Beware all files placed under that path will be forcibly
deleted.

### How to use this software

This software is intended to be used as a launch unit under `systemd`. You need
to place configuration files under `/etc/file-watchdog` and enable the service
using `systemctl`. The unit file is parameterized so you can spawn an arbitary
amount of instances.

## Bug reporting

If you have encountered a bug, file an issue here on Github.

## More information

This softwae is free software under [3-clause BSD license](LICENSE.md). You are
welcome to use, improve, modify and distribute this software under the terms.

file-watchdog &copy; 2019 [Max Chan](xcvista@me.com). All rights reserved.
