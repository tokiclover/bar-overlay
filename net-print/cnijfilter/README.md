NEWS
----

Added a new splitting CUPS backends/filters/utilities with USE flags instead of
a messy multiple packages implementation which need messy back ports and such,
well, not easy to maintain.

To avoid the splitting cruft, just add the follong in `/etc/portage/package.use`:
`=net-print/cnijfilter-${PV} cups canon_printers_MODEL`

Or else, just merge any pariticular package version with printer models, and
enable `cups` USE flag only to the latest version to avoid file collisions.

Wait a sec before merging the package! If old printer models are needed present in
`<net-print/cnijfilter-3.40`, `abi_x86_32` **USE** flag should be enabled if running with
`ABI=amd64` because these packages lack any multilib support. `x86` users can
jump to the following.

If `<net-print/cnijfilter-2.80` is needed, then x86 users would pull in `gtk+:1`
and amd64 user would pull in `gtk+:1[abi_x86_32]` which is not available in the
tree, meaning: impossible for **ABI=amd64**, if +servicetools USE flag is enabled.

USAGE INFO
----------

Actually `canon_printers_MODEL` USE flags are just pulling in `canonMODEL.ppd` file
and a `cifMODEL` binary linked to propriatary blobs (libraries). The ppd file is
the only usefull file in most cases because unless you are building the latest 3.x0
or 4.x0, `cifMODEL` won't work at all for old tarball because this vry old binary
is linked to very old libpng/tiff... libraries.

So one could just extract `canonMODEL.ppd` file and put it in `/etc/cups/ppd` and
and then merge something with `net-print/cnijfilter cups gtk net usb servicetools`.

Beware that +net USE flag pull in propriatary blobs (libraries) which are linked to
network backend.

So just print directly with `cifMODEL IMAGE_FILE &>/tmp/cif.log` to see if keeping that
binary and its related cruft is worth its salt. Notice that everything is redirected
to a file to avoid corrupting a terminal. Just read the file afterwards to see if there
is any meaningfull info. That command have just printed +22MiB garbage to a terminal in
a use case test!

Finaly, if the latest package does not work for you, you can try (3.90 -- 4.00 is a
major update;) 3.70 -- 3.80 is a major update; and 3.40 -- multilib support.

One last note is that when using later backends with older printers than `cnijfilter-3.00`,
IIRC, one has to edit `cnij_usb` to `cnijusb`, newtork backend should be fine, in the
ppd file. Just check CUPS backends used in the ppd file in regards to what is installed
in `/usr/libexec/cups/backend`.

INTERNAL INFO
-------------

net-print/cnijfilter[gtk,servicetools] now compile fine with a patch ported from
[cnijfilter-source-3.80](https://github.com/tokiclover/cnijfilter-source-3.80)
to all version provided here. Remain only the issue with x11-libs/gtk+:1
required by by older ebuilds `<=net-print/cnijfilter-2.70`.

SOURCE FILES NOTE
-----------------

Note: if 2.70 src rpm cannot be found, dead link..., just search the full name
with your favorite search engine, or else, look for *Linux_Print_Filterv270.tgz*
and extract *cnijfilter-common-2.70-2.src.rpm* from that archive; and then put it
to **DISTDIR** (see `/etc/portage/make.conf` for the path.)
