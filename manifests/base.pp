class ispconfig::base inherits hdp {
	# apt-utils
	package { 'apt-utils':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# dialog
	package { 'dialog':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# debconf-utils
	package { 'debconf-utils':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# aptitude
	package { 'aptitude':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# nano
	package { 'nano':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# wget
	package { 'wget':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# curl
	package { 'curl':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# git
	package { 'git':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# lsb-release
	package { 'lsb-release':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	# screenfetch
	package { 'screenfetch':
		ensure => 'installed',
		require => Exec['apt_update'],
	} ->

	file_line { 'screenfetch_rc':
		line => 'screenfetch',
		path => '/root/.bashrc',
	}
}