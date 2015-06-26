Header: bar(-overlay)/README.md

---

Another foo (gentoo) overlay with a few packages...
See *sets/PACKAGE_LIST* for a complete package list.

HOWTO GET THIS OVERLAY
----------------------

**FIRST, DO NOT CLONE THE REPOSITORY MULTIPLE TIMES FOR NOTHING**

To update the repository, one can either use *layman* `layman -s bar`
if the repository was cloned with layman; Or even use `eix-sync` to
sync every overlays and portage tree; Or else, simply use *git* to sync
`git pull --force` (*--force* might be necessary if runned out of luck.)

And don't forget to run `git gc --aggressive` in the repository from
times to times to optimize local disk usage.

### Short variant

    USE=git emerge -av layman
    layman -o https://raw.github.com/tokiclover/bar-overlay/master/bar.xml -f -a bar

### Alternative (re-usable) variant

(Uncomment *overlay_defs* in '/etc/layman/layman.cfg')

    mkdir -p /etc/layman/overlays
    wget -NP /etc/layman/overlays https://raw.github.com/tokiclover/bar-overlay/master/bar.xml
    layman -a bar

### Manual variant

Nothing makes *layman* necessary in this process at all...
Just merge *git* with `emerge -av git`; and then clone the repository with
`mkdir -p /var/db/repos`, and then
`git clone git://github.com/tokiclover/bar-overlay.git /var/db/repos/bar`;
and finaly include `bar.conf` in `/etc/portage/repos.conf/` directory,
or concatenate the content to the file directly with
`cat <bar.conf >>/etc/portage/repos.conf`.

USAGE
-----

Merge all the goodies with: `emerge -avDNu world`

LICENSE
-------

GPL-2

---

vim:fenc=utf-8:
