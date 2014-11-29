class player(
	$mpdcron_home = "/home/mpdcron"
)
{
	File
	{
		owner => "mpdcron",
		group => "audio",
	}


	package { [ "mpd" ]:
		ensure => installed;
	} ->

	file { "/etc/mpd.conf":
		ensure => file,
		source => "puppet:///modules/player/mpd/mpd.conf",
		owner => "mpd",
		group => "audio",
		mode => "0640";
	} ~>

	service { "mpd":
		ensure => running;
	}


	$mpdcron_dir = "${mpdcron_home}/.mpdcron"

	package { [ "mpdcron", "mpc" ]:
		ensure => installed;
	} ->

	user { "mpdcron":
		ensure => present,
		gid => "audio",
		# This is nasty. It's needed becuase the automount module runs udisks-glue as this user as well
		groups => [ "plugdev" ],
	        home => "${mpdcron_home}",
	        managehome => true;
	} ->

	file { "${mpdcron_dir}":
		ensure => directory;
	} ->

	file { "${mpdcron_dir}/mpdcron.conf":
		ensure => file,
	        source => "puppet:///modules/player/mpdcron/mpdcron.conf";
	} ->

	file {
		"${mpdcron_dir}/hooks":
			ensure => directory;
		"${mpdcron_dir}/hooks/player":
			ensure => file,
			source => "puppet:///modules/player/mpdcron/hooks/player";
		"${mpdcron_dir}/hooks/database":
			ensure => file,
			source => "puppet:///modules/player/mpdcron/hooks/database";
		"${mpdcron_dir}/hooks/update":
			ensure => file,
			source => "puppet:///modules/player/mpdcron/hooks/update";
		"${mpdcron_dir}/hooks/play.sh":
			ensure => file,
			source => "puppet:///modules/player/mpdcron/hooks/play.sh";
	} ->

	exec { "mpdcron":
		# path set in site.pp
		command => "mpdcron",
		# We could do it "properly" with creates, but that won't attempt to start folling a dirty shutdown.
		# creates => "${mpdcron_dir}/mpdcron.pid",
		unless => "pgrep mpdcron",
		cwd => "${mpdcron_home}",
		environment => [ "HOME=${mpdcron_home}" ], # not set by user attribute
		user => "mpdcron", # seems to be very limited; no change of HOME, cwd, etc
		group => "audio";
	}


	file { "${mpdcron_home}/buttond.py":
		ensure => file,
		source => "puppet:///modules/player/buttond/buttond.py",
		mode => "0755";
	} ->

	# TODO
	# - This is not yet idempotent because I cannot make unless( pgrep -f ) work properly, under either provider type
	# - I also can't make output redirection work using &>> and the shell provider
	exec { "buttond":
		# Backgrounds itself
		command => "${mpdcron_home}/buttond.py",
		user => "root";
	}
}
