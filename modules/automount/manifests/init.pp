class automount
{
	package { [ "autofs", "exfat-fuse", "ntfs-3g", "dosfstools" ]:
		ensure => installed;
	}
}
