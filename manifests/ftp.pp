class ispconfig::ftp inherits ispconfig {
	warning($::pure_ftpd_version)

	# Docker kernel doesn't have capabilities, so we have to recompile it from sources
	if (str2bool("$is_virtual")) and ($virtual == 'docker') {
		# Install package building helpers
		ensure_packages([
			'dpkg-dev',
			'debhelper',
			'gawk',
			'openbsd-inetd',
		], {
			'ensure' => 'installed',
		})

		file { '/tmp/pureftpd.sh':
			source => 'puppet:///modules/ispconfig/scripts/pureftpd.sh',
			ensure => present,
			require => Package['dpkg-dev','debhelper','openbsd-inetd'],
		} ->

		# Install dependancies
		exec { 'pureftp-build-script':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'bash /tmp/pureftpd.sh',
			timeout => 0,
		}

		

		# Install dependancies
		/*exec { 'pureftp-build-dep':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'apt-get -y build-dep pure-ftpd',
			require => Package['dpkg-dev', 'debhelper', 'openbsd-inetd'],
		} ->

		file { '/tmp/pure-ftpd-mysql':
			ensure => directory,
		} ->

		# Get source
		exec { 'pureftp-get-source':
			cwd => '/tmp/pure-ftpd-mysql',
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'apt-get source pure-ftpd-mysql',
		} ->

		# Build from source
		exec { 'pureftp-build':
			cwd => "/tmp/pure-ftpd-mysql/pure-ftpd-$::pure_ftpd_version",
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => "sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && dpkg-buildpackage -b -uc",
			timeout => 0,
		} ->

		# Install the new deb files
		package { 'pure-ftpd-common':
			provider => dpkg,
			ensure => present,
			source => '/tmp/pure-ftpd-mysql/pure-ftpd-common-$::pure_ftpd_version.deb',
		} ->

		package { 'pure-ftpd-mysql':
			provider => dpkg,
			ensure => present,
			source => '/tmp/pure-ftpd-mysql/pure-ftpd-mysql-$::pure_ftpd_version.deb',
		} ->

		# Prevent pure-ftpd upgrading
		exec { 'pureftp-apt-mark':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => "apt-mark hold pure-ftpd-common pure-ftpd-mysql",
		} ->

		# Setup ftpgroup and ftpuser
		exec { 'pureftp-user':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => "groupadd ftpgroup && useradd -g ftpgroup -d /dev/null -s /etc ftpuser",
		}*/
	}
	else {
		ensure_packages([
			'pure-ftpd-common',
			'pure-ftpd-mysql',
		], {
			'ensure' => 'installed',
		})
	}

	ensure_packages([
		'quota',
		'quotatool',
	], {
		'ensure' => 'installed',
	})

	exec { 'pureftp-virtualchroot':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'sed -i "s/VIRTUALCHROOT=false/VIRTUALCHROOT=true/g" /etc/mime.types',
		#require => Package['pure-ftpd-common'],
	} ->

	exec { 'pure-ftpd-mysql':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'service pure-ftpd-mysql restart',
		#require => Package['pure-ftpd-common'],
	}

	/*service { 'pure-ftpd-mysql':
		enable      => true,
		ensure      => running,
		hasrestart 	=> true,
		hasstatus 	=> false,
		require    => Package['pure-ftpd-mysql'],
	}*/

	if defined(Package['openssl']) {
		file { '/etc/pure-ftpd/conf/TLS':
			ensure => file,
			content => '1',
			#require => Package['pure-ftpd-mysql'],
		} ->

		file { '/etc/ssl/private/':
			ensure => directory,
			owner => 'root',
			group => 'root',
		} ->

		file { '/tmp/openssl.preseed':
			content => template('ispconfig/preseed/openssl.erb'),
			ensure => present,
		} ->

		exec { 'pureftp-ssl-certificate':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'openssl req -x509 -nodes -days 7300 -newkey rsa:4096 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -batch < /tmp/openssl.preseed',
			#require => [File['/tmp/openssl.preseed'], Package['openssl']]
		} ->

		file { '/etc/ssl/private/pure-ftpd.pem':
			ensure => present,
			owner => 'root',
			group => 'root',
			mode => '0600',
			#notify => Service['pure-ftpd-mysql'],
		}
		/* ->

		exec { 'pure-ftpd-mysql-restart':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'service pure-ftpd-mysql restart',
			#require => [File['/tmp/openssl.preseed'], Package['openssl']]
		}*/
	}

	if str2bool("$is_virtual") == false {
		exec { 'quota-fstab':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'sed -i "s/errors=remount-ro/errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/g" /etc/fstab',
			require => Packages['quota','quotatool'],
		} ->

		exec { 'quota-mount':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'mount -o remount /',
			require => Packages['quota','quotatool'],
		} ->

		exec { 'quota-check':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'quotacheck -avugm',
			require => Packages['quota','quotatool'],
		} ->

		exec { 'quota-on':
			path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
			command => 'quotaon -avug',
			require => Packages['quota','quotatool'],
		}
	}
}