class player
{
	package { [ "mpd", "mpdcron", "mpc" ]:
		ensure => installed;
	}
}
