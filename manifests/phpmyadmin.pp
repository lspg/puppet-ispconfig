class ispconfig::phpmyadmin inherits ispconfig {
	file { '/tmp/phpmyadmin.seeds':
		content => template('preseed/phpmyadmin.seeds'),
		ensure => present;
	}

	package { 'phpmyadmin':
		require      => [ File['/tmp/phpmyadmin.seeds'], Package['apache2','php5','mariadb-server'] ]
		responsefile => "/tmp/phpmyadmin.seeds",
		ensure       => installed,
	}
}