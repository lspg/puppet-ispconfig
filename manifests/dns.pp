class ispconfig::dns inherits ispconfig {
	ensure_packages([
		'bind9',
		'dnsutils',
	], {
		'ensure' => 'installed',
		'require' => 'Exec["apt_update"]',
	})

	if str2bool("$is_virtual") {
		package { 'haveged':
			ensure => installed,
			require => Exec['apt_update'],
		}
	}
}