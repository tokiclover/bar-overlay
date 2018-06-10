Header: bar(-overlay)/README.md

---

Yet Another foo [Overlay][1] for [Gentoo][0] (Linux/BSD) with a few packages...
See [package-list](metadata/pkg_desc_index) for a complete package list.

HOWTO GET THIS OVERLAY
----------------------

**FIRST, DO NOT CLONE THE REPOSITORY MULTIPLE TIMES FOR NOTHING**

To update the repository, one can either use *layman* `layman -s bar`
if the repository was cloned with layman; Or even use `eix-sync` to
sync every overlays and portage tree; Or else, simply use *git* to sync
`git pull --force` (*--force* might be necessary if runned out of luck.)

And don't forget to run `git gc --aggressive --prune=all` in the repository from
times to times to optimize local disk usage.

Just merge *git* with `emerge -av git`; and then clone the repository with
`mkdir -p /var/db/repos`, and then
`git clone git://gitlab.com/tokiclover/bar-overlay.git /var/db/repos/bar`;
and finaly include [bar.conf](bar.conf) in `/etc/portage/repos.conf/` directory,
or concatenate the content to the file directly with
`cat <bar.conf >>/etc/portage/repos.conf`.


And finaly `eix-sync` if using eix to get the repository indexed and ready.

USAGE
-----

### Packages

Merge all the goodies with: `emerge -avDNu world`
or merge package sets for the repository (see sets/ for more info.)

### Configuration

Examples of runtime configuration files can be found in this repository
[dotfiles](https://gitlab.com/tokiclover/dotfiles) might be handy to get,
for example, JACK/LADI or mail-utilities @set set up and working in no time!

LICENSE
-------

GPL-2

CLONE/MIRRORS
-------

- https://github.com/tokiclover/bar-overlay;
- git://github.com/tokiclover/bar-overlay.git;
- git@github.com:tokiclover/bar-overlay.git;
- https://gitlab.com/tokiclover/bar-overlay;
- git://gitlab.com/tokiclover/bar-overlay.git;
- git@gitlab.com:tokiclover/bar-overlay.git;

GNUPG FINGERPRINT
---------

pub   rsa2048 2017-04-02 [SC] [expires: 2019-04-02]
AD5D 6311 D85D 1E6A 86A8  CB87 2806 F421 E1E0 0BC2

---

[0]: https://gentoo.org
[1]: https://wiki.gentoo.org/wiki/Overlay

vim:fenc=utf-8:
