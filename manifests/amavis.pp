class ispconfig::amavis inherits ispconfig {
	info('---------------------------------------------')
	info('--- Amavisd-new, SpamAssassin, And Clamav ---')
	info('---------------------------------------------')

	ensure_packages(['amavisd-new','spamassassin','clamav','clamav-daemon','clamav-docs','zoo','unzip','bzip2','arj','nomarch','lzop','cabextract','apt-listchanges','libnet-ldap-perl','libauthen-sasl-perl','daemon','libio-string-perl','libio-socket-ssl-perl','libnet-ident-perl','zip','libnet-dns-perl ','postgrey'],
		'ensure' => 'installed',
		'require' => Exec['apt_upgrade'],
	}

	exec { 'spamassassin-disable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service spamassassin stop && systemctl disable spamassassin",
		require => Package['spamassassin'],
	}
}