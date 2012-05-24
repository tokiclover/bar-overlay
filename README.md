`$Id: bar-overlay/README.textile, 2012/05/11 19:52:20 -tclover Exp $`

---

another foo (portage) overlay with a few package I'd rather emerge than merge manually

to use this overlay execute as root

`% USE=git emerge -av layman`
`% layman -o https://raw.github.com/tokiclover/bar-overlay/master/bar-overlay.xml -f -a bar`

or alternatively... and do not forget to uncomment 

`overlay_defs : /etc/layman/overlays` in `/etc/layman/layman.cfg` and then

`% mkdir -p /etc/layman/overlays`
`% cd /etc/layman/overlays`
`% wget https://raw.github.com/tokiclover/bar-overlay/master/bar-overlay.xml`
`% layman -a bar`

once done, merge all the goodies with: `% emerge -aNDuv @world`

---

`vim:fenc=utf-8:`
