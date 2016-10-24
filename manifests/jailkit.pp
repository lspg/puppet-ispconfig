class ispconfig::jailkit inherits ispconfig {
	ensure_packages([
		'build-essential',
		'autoconf',
		'automake',
		'libtool',
		'flex',
		'bison',
		'debhelper',
		'binutils',
	], {
		'ensure' => 'installed',
		'require' => Exec['apt_update'],
	})

	exec { 'jailkit-download':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz -O /tmp/jailkit.tar.gz',
		require => Package['build-essential','autoconf','automake','libtool','flex','bison','debhelper','binutils',],
	} ->

	exec { 'jailkit-uncompress':
		cwd => '/tmp',
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'tar xvfz jailkit.tar.gz',
	} ->

	exec { 'jailkit-binary':
		cwd => '/tmp/jailkit-2.19',
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => './debian/rules binary',
	} ->

	package { 'jailkit':
		provider => dpkg,
		ensure => latest,
		source => '/tmp/jailkit-2.19.deb',
	}
}