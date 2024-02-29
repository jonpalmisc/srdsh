# SRDsh

SRDsh provides a SSH server (Dropbear) and a collection of standard command
line utilities (toybox) via a single, standalone cryptex. ~~It is intended to be
installed alongside other cryptexi, leveraging the modularity of the cryptex
system, as opposed to jamming all your tools, etc. into a single cryptex.~~

**2024 Update:** Using multiple cryptexes in tandem has a variety of issues;
the original vision I had of maintaining ports of tools for the SRD in multiple
different cryptexes didn't really pan out. A notable recent addition is the
"user" folder in the apps subdirectory, which provides a place to insert
proof-of-concept code, etc. that will automatically be available in `PATH` as
`user-app` via SSH.

> This project is primarily for my own use. I've chosen to make it open source
> in case other researchers find it useful. Support or active maintenance
> should not be expected.

### Build System

Another goal of this project was an attempt to clean up the build system of the
example cryptex provided in the SRD repo, starting with the tools I most
frequently use first. Some "features" of SRDsh's build setup compared to the
example cryptex are:

- no use of recursive make (outside of building submodules);
- a more correct dependency graph that prevents redundant rebuilds; and
- inclusion of dependencies as submodules instead of auto-fetching tarballs.

You may find the helpers in [`mk/`](mk/) and the ideas in the root makefile
useful in other projects.

## Build

To build, clone the SRDsh repo (with submodules) and run `make`:

```sh
git clone --recurse-submodules git@github.com:jonpalmisc/srdsh.git
make
```
> You will need the Xcode CLI tools installed and `cryptexctl` available in
> your path.

To install the cryptex on your device, you can use the `install` convenience
target provided:

```sh
make install
```

Note that you will likely need to set the `CRYPTEXCTL_UDID` environment
variable in your shell for the above command to work.

## Usage

Once installed, you should be able to SSH into your device as you'd expect:

```sh
ssh root@<device-ip>
```

## License

SRDsh is licensed under the [Apache 2.0](LICENSE.txt) license. Portions of
SRDsh are based on code from the SRD repo's example cryptex, also licensed
under the Apache 2.0 license.
