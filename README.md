# fswatch.swift

Swift bindings to [libfswatch](https://github.com/emcrisostomo/fswatch), a cross-platform file monitoring library.

## Installation

This is a _Swift Package Manager_ package.

## Usage

Have a look at `fswatch-example`. A proper documentation will come when this reaches beta status.

## Status

This is pre-alpha.

## Troubleshooting

If compiling fails on your system because of `libfswatch.pc` not being found, then your
operating system package is missing the proper development files. You can fix this by creating
the proper `pkgconfig` file like that and putting this into your `$(prefix)/lib/pkgconfig/`directory.

```
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libfswatch
Description: libfswatch
URL: https://github.com/emcrisostomo/fswatch/tree/master/libfswatch
Version: 1.16.0
Requires:
Libs: -L${libdir} -lfswatch
Cflags: -I${includedir}

```

This is just a workaround though, as your operating system package needs to be fixed.

## License

Feel free to use under the term of the MIT. All contributions welcome. Stay safe and sound!