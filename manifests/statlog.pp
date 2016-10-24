class ispconfig::statlog inherits ispconfig {
	ensure_packages([
		'vlogger',
		'webalizer',
		'awstats',
		'geoip-database',
		'libclass-dbi-mysql-perl',
	], {
		'ensure' => 'installed',
		'require' => Exec['apt_update'],
	})

	exec { 'awstats-cron':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'sed -i "s/^/#/g" /etc/cron.d/awstats',
		require => Package['awstats'],
	}
}