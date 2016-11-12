NEWS
----

Added a new splitting CUPS backends/filters/drivers with USE flags instead of
a messy multiple packages implementation which need messy back ports and such,
well, not easy to maintain.

To avoid the splitting cruft, just add the follong in `/etc/portage/package.use`:
`=net-print/cnijfilter-${PV} backends drivers canon_printers_MODEL`

Of course, the need to check net-print/cnijfilter-**$VERSION** before hand. Or else...
`emerge` would prompt to chose, at least, a printer model and pull in the latest
version available and prompt to enale `backends` **USE** flag for it! In this
case, disabling `drivers` **USE** flag might be necessary, because it is enabled
by defaut!, or else... chossing a printer model at least is necessary.

Wait a sec before merging the package! If old printer models are needed present in
`<net-print/cnijfilter-3.40`, `abi_x86_32` **USE** flag should be enabled if running with
`ABI=amd64` because these packages lack any multilib support. `x86` users can
jump to the following.

If `<net-print/cnijfilter-2.80` is needed, then x86 users would pull in `gtk+:1`
and amd64 user would pull in `gtk+:1[abi_x86_32]` which is not available in the
tree, meaning: impossible for **ABI=amd64**, if +servicetools USE flag is enabled.

USAGE INFO
----------

Actually the mis-named +drivers USE flag is just pulling in `canonMODEL.ppd` file
and a `cifMODEL` binary linked to propriatary blobs (libraries). The ppd file is
the only usefull file in most cases because unless you are building the latest 3.x0
or 4.x0, `cifMODEL` won`t work at all for old tarball because this vry old binary
is linked to very new libpng/tiff...

So one could just extract `canonMODEL.ppd` file and put it in `/etc/cups/ppd` and
and then merge something with `net-print/cnijfilter backends -drivers`.

Beware that +net USE flag pull in propriatary blobs (libraries) which are linked to
network backend.

So just print directly with `cifMODEL IMAGE_FILE &>log` to see if keeping that
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

Actually, old ebuilds used to be mergeable with `-servicetools -gtk` **USE** flags. Alghough
cnijfilter-4.[01]0 changed it a little bit because now +gtk build, however,
the same old code in *'cngpijmon'* and *'cngpmnt'* present only in cnijfilter-3.[89]0
ported, or to be precise copied *'as is'* I think, to *'cnijnpr'* in cnijfilter-4.[01]0
do not compile and throw the same (old) errors! 

So cnijfilter-{2.[6-9],3.[0-9]}0[-servicetools,-gtk] is compilable while
cnijfilter-4.[01]0[-servicetools,+gtk] compile just fine! 

I don't really know where the whole old code in *'cngpijmon'* present in old
tarball went in cnijfilter-4.x0 nor the *'maintenance'* present in the last 3.x0.
It seems *'cngpijmon/cnijnpr'* was moved and *'lgmon'* API changed because there is a
new *'lgmon2'* in 4.x0 while many chunk of code where left *'as is'* which are not
compilable since the old days!

The oddity of the very old packages is a dependency to `gtk+:1`. So unless you have
it installed, it is imposile to pass src_prepare because aclocal fails on a
missing *AM GTK MACRO* (with dep to >=gtk+-1.2.6:1).

SOURCE FILES NOTE
-----------------

Note: if 2.70 src rpm cannot be found, dead link..., just search the full name
with your favorite search engine, or else, look for *Linux_Print_Filterv270.tgz*
and extract *cnijfilter-common-2.70-2.src.rpm* from that archive; and then put it
to **DISTDIR** (see `/etc/portage/make.conf` for the path.)
