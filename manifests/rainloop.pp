class ispconfig::rainloop inherits ispconfig {
	file { '/var/www/rainloop':
		ensure => directory,
		require => Class['apache'],
		owner => 'www-data',
		group => 'www-data',
		mode => '0750',
	} ->

	exec { 'rainloop-install':
		cwd => '/var/www/rainloop',
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'curl -s http://repository.rainloop.net/installer.php | php',
		require => Package['curl'],
	} ->

	file { '/etc/apache2/conf-available/rainloop.conf':
		ensure => present,
		source => 'puppet:///modules/ispconfig/etc/apache2/conf-available/rainloop.conf',
		owner => 'www-data',
		group => 'www-data',
		mode => '0750',
		require => Class['apache'],
		notify  => Class['apache::service'],
	} ->

	exec { 'rainloop-enable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'a2enconf rainloop',
	}
}