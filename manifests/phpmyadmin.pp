class ispconfig::phpmyadmin inherits ispconfig {
	
	if defined(Package['php5']) {
		file { '/tmp/phpmyadmin.seeds':
			content => template('phpmyadmin_preseed.erb'),
			ensure => present,
		} ->

		package { 'phpmyadmin':
			require      => [ File['/tmp/phpmyadmin.seeds'], Package['apache2','php5','mariadb-server'] ],
			responsefile => "/tmp/phpmyadmin.seeds",
			ensure       => installed,
		}
	}
	if defined(Package['php7.0']) {
		class { 'phpmyadmin': }
	}
}