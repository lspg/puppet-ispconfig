class ispconfig::amavis inherits ispconfig {
	ensure_packages([
		'amavisd-new',
		'apt-listchanges',
		'arj',
		'bzip2',
		'cabextract',
		'clamav',
		'clamav-daemon',
		'clamav-docs',
		'daemon',
		'libauthen-sasl-perl',
		'libnet-ldap-perl',
		'libnet-dns-perl',
		'libio-string-perl',
		'libio-socket-ssl-perl',
		'libnet-ident-perl',
		'lzop',
		'nomarch',
		'postgrey',
		'spamassassin',
		'unzip',
		'zip',
		'zoo',
	], {
		'ensure' => 'installed',
	})

/*	package { 'amavisd-new':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'spamassassin':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'clamav':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'clamav-daemon':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'clamav-docs':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'zoo':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'unzip':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	if ! defined(Package['bzip2']) {
		package { 'bzip2':
			ensure => 'installed',
			require => [ Exec['apt_upgrade'], Package['unzip'] ],
		}
	}

	package { 'arj':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'nomarch':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'lzop':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'cabextract':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'apt-listchanges':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libnet-ldap-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libauthen-sasl-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'daemon':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libio-string-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libio-socket-ssl-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libnet-ident-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'zip':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'libnet-dns-perl ':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}

	package { 'postgrey':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	}*/

	exec { 'spamassassin-disable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service spamassassin stop && systemctl disable spamassassin",
		require => Package['spamassassin'],
	}
}