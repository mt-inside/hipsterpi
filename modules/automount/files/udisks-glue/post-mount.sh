#!/bin/bash

exec >> /tmp/mpdcron_hooks.log

echo "udisks-glue post-mount - forcing mpd database update"
mpc update
