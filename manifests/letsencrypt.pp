class ispconfig::letsencrypt inherits ispconfig {
	package { 'python-certbot-apache':
		ensure => installed,
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}
}