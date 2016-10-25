class ispconfig::test inherits ispconfig {
	package { 'gawk':
		ensure => latest,
		#require => Exec['apt_update'],
	} ->

	file { '/tmp/pure-ftpd-mysql/pure-ftpd-1.0.36':
		ensure => directory,
		owner => 'root',
		group => 'root',
	}

	$myversion = generate ("/bin/bash", "-c", "/bin/ls -l /tmp/pure-ftpd-mysql | grep pure-ftp | awk '{print $9}'")
	warning($myversion)
}