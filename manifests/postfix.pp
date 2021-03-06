class ispconfig::postfix inherits ispconfig {
	ensure_packages([
		'dovecot-imapd',
		'dovecot-lmtpd',
		'dovecot-mysql',
		'dovecot-pop3d',
		'dovecot-sieve',
		'getmail4',
		'postfix',
		'postfix-mysql',
		'postfix-doc',
		'rkhunter',
	], {
		'ensure' => installed,
		'require' => Exec['apt_update'],
	})

	file { '/tmp/postconf.sh':
		ensure => 'present',
		source => 'puppet:///modules/ispconfig/scripts/postconf.sh',
		owner => 'root',
		group => 'root',
		mode => '0770',
		require => Package['postfix'],
	} ->
	
	exec { '/tmp/postconf.sh':
		require => File['/tmp/postconf.sh'],
	} ->

	exec { 'postfix-conf-clean':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "sed -i '/^#/d' /etc/postfix/main.cf && sed -i '/^#/d' /etc/postfix/master.cf",
	} ->

	exec { 'postfix-restart':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "postfix stop && postfix start",
	}
}