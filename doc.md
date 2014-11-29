How it works
=======
* Disk is inserted
* kernel notices, tells udev
* udev notices, udisks is subscribed over dbus
* udisks notices, udisks-glue is subscribed over dbus
* udisks-glue runs our hook script
* hook script causes mpc to update its database by re-scanning /media
* mpdcron is subscribed to mpd for events
* mpdcron gets DATABASE hook from mpd
* DATABASE hook causes mpd's playlist to be blanked and everything in the database added

Debugging
======
To debug, you probably want: vim, git, vim-puppet

Notes
=====
Automount
---------

Options:
* systemd - not on debian 7.6
* halevt - uses HAL, HAL is dead
* ivman - uses HAL, HAL is dead
* udev - can apparently be configured to do automount, but amoung the many problems is that it will only do so as root
* udiskie - python script that subscribes to udisks on dbus. Works, but does "native" mounts, which don't cause inotify events, and is not hookable
* udisks-glue - Chosen. subscribes to udisks on dbus, can be configured to automount and call hooks. We use this (using the hooks to kick mpd to rescan because of the lack of inotify events for mounts)
* uam - connects to udev, sounds nice. Alas it's an Arch Linux project, available on Gentoo but not on Debian 7.6
* autofs - old but just about works. Nice thing is that because it mounts autofs over /media, and then other volumes beneath that, it's able to raise inotify events for (un)mount. The bad point is that unmount is lazy, based on a timeout (which can also go off if it thinks you're not using the disk), and it doesn't deal nicely with unmounting fuse volumes for some reason. Also, it passes the -n mount option, which isn't supported by the ancient version of exfat-fuse (0.9.7, 2009) that ships with Debian 7.6, requiring a script wrapping the mount helper to strip it

Playback
--------

Options:
* alsaplayer - "Failed to load text interface. This is bad"
* mpg123 - Think it only plays mp3s, would have to be driven manually
* mpd - Chosen. Has the notion of a local media library that it wants to scan and play from. We configure that to be /media, where the disks are mounted. It should be able to be given files direct over its socket but I simply cannot make that work. Note: the docs are bad; "mpc listall" will give you all files found in the media directory, "mpc playlist" will give you all the tracks in the "main" playlist (these are not the same)
