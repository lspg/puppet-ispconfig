class ispconfig::step8 inherits ispconfig {
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
		'ensure' => 'installed',
	})

	file { '/etc/postfix/master.cf':
		ensure => 'present',
		require => Package['postfix'],
	} ->
	
	file_line { 'postfix_submission_inet':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#submission inet n       -       -       -       -       smtpd',
		line   => 'submission inet n       -       -       -       -       smtpd',
	} ->

	file_line { 'postfix_smtpd_tls_security_level':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#  -o smtpd_tls_security_level=encrypt',
		line   => '  -o smtpd_tls_security_level=encrypt',
	} ->

	file_line { 'postfix_smtpd_sasl_auth_enable':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		multiple => true,
		match  => '^#  -o smtpd_sasl_auth_enable=yes',
		line   => '  -o smtpd_sasl_auth_enable=yes',
	} ->

	file_line { 'postfix_smtpd_client_restrictions':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		multiple => true,
		match  => '^#  -o smtpd_client_restrictions=$mua_client_restrictions',
		line   => '  -o smtpd_client_restrictions=$mua_client_restrictions',
	} ->

	file_line { 'postfix_smtps_smtpd':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#smtps     inet  n       -       -       -       -       smtpd',
		line   => 'smtps     inet  n       -       -       -       -       smtpd',
	} ->

	file_line { 'postfix_syslog_name':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#  -o syslog_name=postfix/submission',
		line   => '  -o syslog_name=postfix/submission',
	} ->

	file_line { 'postfix_syslog_name_smtps':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#  -o syslog_name=postfix/smtps',
		line   => '  -o syslog_name=postfix/smtps',
	} ->

	file_line { 'postfix_smtpd_tls_wrappermode':
		ensure => present,
		path   => '/etc/postfix/master.cf',
		match  => '^#  -o smtpd_tls_wrappermode=yes',
		line   => '  -o smtpd_tls_wrappermode=yes',
	} ->

	# ------ Enhanced e-mail SPAM protection
	exec { 'enchanced-spam-protect':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_invalid_hostname, reject_non_fqdn_hostname, reject_unknown_recipient_domain, reject_non_fqdn_recipient, reject_unauth_destination, reject_non_fqdn_sender, reject_unknown_sender_domain, reject_unknown_recipient_domain, reject_rbl_client cbl.abuseat.org,reject_rbl_client dul.dnsbl.sorbs.net,reject_rbl_client ix.dnsbl.manitu.net, check_recipient_access mysql:/etc/postfix/mysql-virtual_recipient.cf, reject_unauth_destination'",
	} ->

	exec { 'postfix-stop':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service postfix stop",
	} ->

	file { '/var/spool/postfix/pid/master.pid':
		ensure => absent,
	} ->

	file { '/var/lib/postfix/master.lock':
		ensure => absent,
	} ->

	exec { 'postfix-start':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service postfix start",
	}
}