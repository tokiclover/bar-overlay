$Id: bar-overlay/README.md, 2014/08/31 07:35:10 -tclover Exp $

---

another foo (gentoo) overlay with a few packages...

to use this overlay execute as root

`% USE=git emerge -av layman
`% layman -o https://raw.github.com/tokiclover/bar-overlay/master/bar.xml -f -a bar

or alternatively... and do not forget to uncomment *overlay_defs*

`% grep overlay_defs /etc/layman/layman.cfg
`overlay_defs : /etc/layman/overlays

`% mkdir -p /etc/layman/overlays
`% wget -NP /etc/layman/overlays https://raw.github.com/tokiclover/bar-overlay/master/bar.xml
`% layman -a bar

once done, merge all the goodies with: `% emerge -aNDuv world

---

vim:fenc=utf-8:
