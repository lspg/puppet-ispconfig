class ispconfig::mysql inherits ispconfig {
	info('------------------------')
	info('--- Installing MySQL ---')
	info('------------------------')

	class { '::mysql::server':
		package_name  => 'mariadb-server',
		#remove_default_accounts => true,
		create_root_user => true,
		create_root_my_cnf => true,
		root_password => 'root',
		require => Exec['apt_upgrade'],
		grants => {
			'root@localhost/*.*' => {
				ensure     => 'present',
				options    => [ 'GRANT' ],
				privileges => [ 'ALL' ],
				table      => '*.*',
				user       => 'root@localhost',
			},
		} 
	} ->

	class { '::mysql::server::backup':
		backupdir => '/var/mysql-backups',
		require => Exec['apt_upgrade'],
	} ->

	class { '::mysql::server::mysqltuner':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	class { '::mysql::client':
		package_name => 'mariadb-client',
		require => Exec['apt_upgrade'],
	} ->

	/*exec { 'mysql_root_access':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'mysql -u root --password=root -h localhost -e "grant all privileges on *.* to \'root\'@\'localhost\' IDENTIFIED BY \'root\' with grant option;"',
	} ->*/

	file_line { 'mysql_disable_bind':
		ensure => present,
		path   => '/etc/mysql/my.cnf',
		match  => '^bind-address           = 127.0.0.1',
		line   => '#bind-address           = 127.0.0.1',
	} ->

	exec { 'mysql_custom_conf':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'sed -i "s/skip-external-locking/skip-external-locking\nskip-innodb\ndefault-storage-engine = myisam\nlong_query_time = 1\nlog-bin = \/var\/log\/mysql\/mysql-bin.log\nsync_binlog = 1/g" /etc/mysql/my.cnf',
	} ->

	exec { 'mysql-restart':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service mysql restart",
	}
}