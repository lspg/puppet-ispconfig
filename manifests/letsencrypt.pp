class ispconfig::letsencrypt inherits ispconfig {
	package { 'python-certbot-apache':
		ensure => installed,
		install_options => '-t jessie-backports',
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}
}