class ispconfig::mysql inherits ispconfig {
	class { '::mysql::server':
		package_name  => 'mariadb-server',
		#remove_default_accounts => true,
		#create_root_user => true,
		#create_root_my_cnf => true,
		root_password => $::ispconfig::mysql_root_pwd,
		grants => {
			'root@localhost/*.*' => {
				ensure     => 'present',
				options    => [ 'GRANT' ],
				privileges => [ 'ALL' ],
				table      => '*.*',
				user       => 'root@localhost',
			},
		},
		override_options => {
			'mysqld' => {
				'bind-address' => '127.0.0.1',
				'skip-innodb' => true,
				'default-storage-engine' => 'myisam',
				'long_query_time' => '1',
				'log-bin' => '/var/log/mysql/mysql-bin.log',
				'sync_binlog' => '1',
			},
		},
		require => Exec['apt_update'],
	} ->

	class { '::mysql::server::backup':
		backupdir => '/var/backup/mysql',
	} ->

	class { '::mysql::server::mysqltuner':
		ensure => 'installed',
	} ->

	class { '::mysql::client':
		package_name => 'mariadb-client',
	} ->

	file { '/tmp/mysql_secure_installation.seeds':
		content => template('ispconfig/preseed/mysql_secure_installation.erb'),
		ensure => present,
	} ->

	exec { 'mysql_secure_installation':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'mysql_secure_installation < /tmp/mysql_secure_installation.seeds',
		require => File['/tmp/mysql_secure_installation.seeds'],
	}
}