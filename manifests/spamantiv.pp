class ispconfig::spamantiv inherits ispconfig {
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

	exec { 'spamassassin-disable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service spamassassin stop && systemctl disable spamassassin",
		require => Package['spamassassin'],
	}
}