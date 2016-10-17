class ispconfig::sources inherits ispconfig {
	class { 'apt':
		purge => {
			'sources.list' => true,
		},
	} ->

	# Non free repo required for apache mod_fastcgi
	apt::source { "jessie":
		location => 'http://httpredir.debian.org/debian',
		release  => "jessie",
		repos    => 'main contrib non-free',
		include  => {
			'deb' => true,
			'src' => true,
		},
	} ->

	apt::source { "jessie-security":
		location => 'http://security.debian.org/',
		release  => "jessie/updates",
		repos    => 'main contrib non-free',
		include  => {
			'deb' => true,
			'src' => true,
		},
	} ->

	apt::pin { 'jessie':
		release => "jessie",
		priority => 500,
	} ->

	apt::source { 'jessie-backports':
		location => 'http://ftp.debian.org/debian',
		release  => 'jessie-backports',
		repos    => 'main contrib non-free',
		include  => {
			'deb' => true,
			'src' => false,
		},
	} ->

	apt::pin { 'jessie-backports':
		release => "jessie-backports",
		priority => -1,
	} ->

	# Testing repository to get last Apache version
	/*apt::source { "testing":
		location => 'http://httpredir.debian.org/debian',
		release  => 'testing',
		repos    => 'main contrib non-free',
		include  => {
			'deb' => true,
			'src' => false,
		},
	} ->

	apt::source { 'testing-security':
		location => 'http://security.debian.org/',
		release  => 'testing/updates',
		repos    => 'main contrib non-free',
		include  => {
			'deb' => true,
			'src' => false,
		},
	} ->

	apt::pin { 'testing':
		packages => '*',
		release => 'testing',
		priority => -1,
	} ->

	apt::pin { 'testing-apache':
		packages => 'apache2 apache2-bin apache2-data ssl-cert apache2-utils libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.1-0 ssl-cert libssl1.0.2 libnghttp2-14',
		release => 'testing',
		priority => 990,
	} ->*/

	# dotdeb repository
	class { 'dotdeb': } ->

	# XMPP
	apt::source { 'metronome':
		location => 'http://packages.prosody.im/debian/',
		release  => "jessie",
		repos    => 'main',
		include  => {
			'deb' => true,
			'src' => false,
		},
	} ->

	apt::pin { 'metronome':
		release => "jessie",
		priority => 500,
	} ->

	class { 'apt_update': } ->

	exec { 'apt_upgrade':
		command => 'apt-get update --fix-missing && apt-get -y --force-yes upgrade',
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
#		require => Exec['apt_update'],
	} ->

	# apt-transport-https
	package { 'apt-transport-https':
		ensure => 'installed',
		install_options => '-y',
		require => Exec['apt_upgrade'],
	} ->

	# debian-keyring
	package { 'debian-keyring':
		ensure => 'installed',
		install_options => '-y',
		require => Exec['apt_upgrade'],
	} ->

	# debian-archive-keyring
	package { 'debian-archive-keyring':
		ensure => 'installed',
		install_options => '-y',
		require => Exec['apt_upgrade'],
	}
}