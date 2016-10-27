class ispconfig::postfix inherits ispconfig {
	
	/*if ! defined(Package['postfix']) {
		package { 'postfix':
			responsefile => template('ispconfig/preseed/postfix.erb'),
			ensure       => installed,
		}
	}*/

	file { '/tmp/postfix.preseed':
		content => template('ispconfig/preseed/postfix.erb'),
		ensure => present,
	}

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
		'responsefile' => '/tmp/postfix.preseed',
		'require' => File['/tmp/postfix.preseed'],
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

	exec { 'postfix-restart':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service postfix restart",
	}

	/*include postfix

	postfix::config { 'relay_domains':
		ensure  => present,
		value   => 'localhost host.foo.com',
	}*/
}