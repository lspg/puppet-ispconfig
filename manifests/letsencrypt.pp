class ispconfig::letsencrypt inherits ispconfig {
	apt::pin { 'certbot':
		packages => 'python-certbot-apache',
		release => 'backports',
		priority => 990,
	} ->

	package { 'python-certbot-apache':
		ensure => installed,
		install_options => '-t jessie-backports',
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}
}