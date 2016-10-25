class ispconfig::jailkit inherits ispconfig {
	ensure_packages([
		'build-essential',
		'autoconf',
		'automake',
		'libtool',
		'flex',
		'bison',
		'debhelper',
	], {
		'ensure' => 'installed',
		'require' => Exec['apt_update'],
	})

	if ! defined(Package['binutils']) { 
		package { 'binutils':
			ensure => latest,
			require => Exec['apt_update'],
		}
	}

	if ! defined(Package['unzip']) { 
		package { 'unzip':
			ensure => latest,
			require => Exec['apt_update'],
		}
	}

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
		command => '/tmp/jailkit-2.19/./debian/rules binary',
	} ->

	package { 'jailkit':
		provider => dpkg,
		ensure => present,
		source => '/tmp/jailkit-2.19.deb',
	} ->

	# Fix chrooted sftp : http://symka.blogspot.fr/2013/05/jailkit-ispconfig-ubuntu-1204-sftp.html
	exec { 'chroot-sftp-fix':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "sed -i 's/^libraries = \/lib\/libnsl.so.1/libraries = \/lib\/libnsl.so.1, \/lib64\/libnsl.so.1, \/lib\/libnss*.so.2, \/lib64\/libnss*.so.2, \/lib64\/libnss*.so.2, \/lib\/x86_64-linux-gnu\/libnsl.so.1, \/lib\/x86_64-linux-gnu\/libnss*.so.2/g' /etc/jailkit/jk_init.ini",
	} ->

	exec { 'chroot-sftp-fix-2':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "sed -i 's/^libraries = \/lib\/libnss_dns.so.2/libraries = \/lib\/libnss_dns.so.2, \/lib64\/libnss_dns.so.2, \/lib\/x86_64-linux-gnu\/libnss_dns.so.2/g' /etc/jailkit/jk_init.ini",
	}
}