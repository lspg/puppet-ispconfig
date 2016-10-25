class ispconfig::test inherits ispconfig {
	warning($::pure_ftpd_version)

	package { 'gawk':
		ensure => latest,
		#require => Exec['apt_update'],
	} ->

	file { '/tmp/pure-ftpd-mysql':
		ensure => directory,
		owner => 'root',
		group => 'root',
	} ->

	file { '/tmp/pure-ftpd-mysql/$::pure_ftpd_version':
		ensure => directory,
		owner => 'root',
		group => 'root',
	}
	
	#apt-cache madison pure-ftpd-mysql | awk '{print $3}'
	#TEST=$(apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}')
}