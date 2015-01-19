Header: bar(-overlay)/README.md

---

Another foo (gentoo) overlay with a few packages...
See *profiles/package.list* for package list.

HOWTO GET THIS OVERLAY
----------------------

### Short variant

    USE=git emerge -av layman
    layman -o https://raw.github.com/tokiclover/bar-overlay/master/bar.xml -f -a bar

### Alternative (re-usable)

(Uncomment *overlay_defs* in '/etc/layman/layman.cfg')

    mkdir -p /etc/layman/overlays
    wget -NP /etc/layman/overlays https://raw.github.com/tokiclover/bar-overlay/master/bar.xml
    layman -a bar

USAGE
-----

Merge all the goodies with: `emerge -avDNu world`

To update the repository, one can either use *layman* `layman -s bar`
if the repository was cloned with layman; or even use `eix-sync` to
sync portage/overlays; or else, use *git* to sync `git pull` should
suffice or add *-f* if you've runned out of luck.

**SIMPLY PUT, DO NOT CLONE MULTIPLE TIMES FOR NOTHING**

And don't forget to run `git gc --aggressive` in the repository from
times to times to optimize local disk usage.

LICENSE
-------

GPL-2

---

vim:fenc=utf-8:
