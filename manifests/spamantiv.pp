class ispconfig::spamantiv inherits ispconfig {
	ensure_packages([
		'amavisd-new',
		'apt-listchanges',
		'arj',
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
		'zip',
		'zoo',
	], {
		'ensure' => 'installed',
	})

	if ! defined(Package['bzip2']) {
		package { 'bzip2':
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

	exec { 'spamassassin-disable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service spamassassin stop && systemctl disable spamassassin",
		require => [Package['spamassassin'],Package['bzip2']]
	}
}