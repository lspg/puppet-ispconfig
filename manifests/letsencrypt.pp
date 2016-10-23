class ispconfig::letsencrypt inherits ispconfig {
	apt::pin { 'certbot':
		packages => 'python-certbot-apache',
		release => 'backports',
		priority => 990,
	} ->

	package { 'python-certbot-apache':
		ensure => installed,
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}
}