Header: bar(-overlay)/README.md

---

another foo (gentoo) overlay with a few packages...
package list is: *profiles/package.list*

### to get this overlay

    % USE=git emerge -av layman

    % layman -o https://raw.github.com/tokiclover/bar-overlay/master/bar.xml -f -a bar

### another alternative

and do not forget to uncomment *overlay_defs*

    % grep overlay_defs /etc/layman/layman.cfg

    overlay_defs : /etc/layman/overlays

    % mkdir -p /etc/layman/overlays

    % wget -NP /etc/layman/overlays https://raw.github.com/tokiclover/bar-overlay/master/bar.xml

    % layman -a bar

### usage/checking

merge all the goodies with: `% emerge -aNDuv world`

To update the repository, one can either use *layman* `layman -s bar`
if the repository was cloned with layman; or even use `eix-sync` to
sync portage/overlays; or else, use *git* to sync `git pull` should
suffice or add *-f* if you've runned out of luck.

SIMPLY PUT, DO NOT CLONE MULTIPLE TIMES FOR NOTHING.

### license

GPL-2

---

vim:fenc=utf-8:
