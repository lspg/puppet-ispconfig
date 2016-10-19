class ispconfig::phpmyadmin inherits ispconfig {
	if defined(Package['php5']) {
		file { '/tmp/phpmyadmin.preseed':
			content => template('ispconfig/preseed/phpmyadmin.erb'),
			ensure => present,
		} ->

		package { 'phpmyadmin':
			require      => [ File['/tmp/phpmyadmin.preseed'], Class['apache'], Package['php5','mariadb-server'] ],
			responsefile => "/tmp/phpmyadmin.preseed",
			ensure       => installed,
		}
	}
	if defined(Package['php7.0']) {
		class { 'phpmyadmin': }
	}
}