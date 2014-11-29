#!/bin/bash

exec >> /tmp/mpdcron_hooks.log

echo "udisks-glue post-unmount - forcing mpd database update"
mpc update
