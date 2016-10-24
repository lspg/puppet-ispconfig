class ispconfig::letsencrypt inherits ispconfig {
	/*package { 'python-certbot-apache':
		ensure => installed,
		install_options => '-y -t jessie-backports',
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}*/

	exec { 'certbot-install':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "apt-get install python-certbot-apache -t jessie-backports",
		require => [Apt::Pin['jessie-backports'], Exec['apt_update']],
	}
}