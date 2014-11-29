class automount(
	$mpdcron_home = "/home/mpdcron"
)
{
	File
	{
		owner => "mpdcron",
		group => "audio",
	}


	package { [ "udisks-glue", "exfat-fuse", "ntfs-3g", "dosfstools" ]:
		ensure => installed;
	} ->

	file { "${mpdcron_home}/.udisks-glue.conf":
		ensure => file,
		source => "puppet:///modules/automount/udisks-glue/udisks-glue.conf";
	} ->

	file {
		"${mpdcron_home}/post-mount.sh":
			ensure => file,
			mode => "0755",
			source => "puppet:///modules/automount/udisks-glue/post-mount.sh";
		"${mpdcron_home}/post-unmount.sh":
			ensure => file,
			mode => "0755",
			source => "puppet:///modules/automount/udisks-glue/post-unmount.sh";
	} ->

	exec { "udisks-glue":
		# path set in site.pp
		command => "udisks-glue",
		unless => "pgrep udisks-glue",
		cwd => "${mpdcron_home}",
		environment => [ "HOME=${mpdcron_home}" ], # not set by user attribute
		user => "mpdcron", # seems to be very limited; no change of HOME, cwd, etc
		group => "audio";
	}
}
