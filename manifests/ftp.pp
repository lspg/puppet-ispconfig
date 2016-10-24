class ispconfig::ftp inherits ispconfig {
	ensure_packages([
		'pure-ftpd-common',
		'pure-ftpd-mysql',
		'quota',
		'quotatool',
	], {
		'ensure' => 'installed',
	})

	exec { 'pureftp-virtualchroot':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'sed -i "s/VIRTUALCHROOT=false/VIRTUALCHROOT=true/g" /etc/mime.types',
		require => Package['pure-ftpd-common'],
	}

	if defined(Package['openssl']) {
		file { '/etc/pure-ftpd/conf/TLS':
			ensure => file,
			content => '1',
			require => Packages['pure-ftpd-common','openssl'],
		}

		file { '/etc/ssl/private/pure-ftpd.pem':
			ensure => present,
			owner => 'root',
			group => 'root',
			mode => '0600',
			require => File['/etc/pure-ftpd/conf/TLS'],
			notify => Service['pure-ftpd-mysql'],
		}
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