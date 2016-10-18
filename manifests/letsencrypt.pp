class ispconfig::letsencrypt inherits ispconfig {
	package { 'python-certbot-apache':
		ensure => installed,
		install_options => '-t jessie-backports',
		require => Exec['apt_update'],
	}
}