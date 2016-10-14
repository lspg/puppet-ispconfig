class ispconfig::docker inherits ispconfig {
	# rsyslog
	package { 'rsyslog':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# rsyslog-relp
	package { 'rsyslog-relp':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# aptitude
	package { 'aptitude':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# logrotate
	package { 'logrotate':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# supervisor
	package { 'supervisor':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	file { "/var/log/auth.log":
		ensure  => present,
	} ->

	file { '/var/log/supervisor':
		ensure => directory,
	}
}