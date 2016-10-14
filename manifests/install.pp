class ispconfig::install inherits ispconfig {
	# SSH
	package { 'ssh':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'openssh-server':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	# SHELL TEXT EDITOR
	package { 'nano':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	# CONFIGURE HOSTNAME
	class { 'hostname':
		hostname => $::ispconfig::hostname,
		domain   => $::ispconfig::domain,
	} ->

	# CHANGE DEFAULT SHELL
	exec { 'set-default-shell':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'echo "dash dash/sh boolean no" | debconf-set-selections && dpkg-reconfigure dash',
	}

	class { '::ntp':
		package_ensure => installed,
		require => Exec['apt_upgrade'],
	} ->

	# POSTFIX, DOVECOT
	package { 'postfix':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'postfix-mysql':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'postfix-doc':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'getmail4':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'rkhunter':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'dovecot-imapd':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'dovecot-pop3d':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'dovecot-mysql':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'dovecot-sieve':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'dovecot-lmtpd':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
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

	exec { 'postfix-restart':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service postfix restart",
	} ->

	# Utils
	package { 'openssl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'binutils':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'sudo':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	# MySQL
	class { '::mysql::server':
		package_name  => 'mariadb-server',
		#remove_default_accounts => true,
		create_root_user => true,
		create_root_my_cnf => true,
		root_password => 'root',
		require => Exec['apt_upgrade'],
		grants => {
			'root@localhost/*.*' => {
				ensure     => 'present',
				options    => [ 'GRANT' ],
				privileges => [ 'ALL' ],
				table      => '*.*',
				user       => 'root@localhost',
			},
		} 
	} ->

	class { '::mysql::server::backup':
		backupdir => '/var/mysql-backups',
		require => Exec['apt_upgrade'],
	} ->

	class { '::mysql::server::mysqltuner':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	class { '::mysql::client':
		package_name => 'mariadb-client',
		require => Exec['apt_upgrade'],
	} ->

	exec { 'mysql_root_access':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'mysql -u root --password=root -h localhost -e "grant all privileges on *.* to \'root\'@\'localhost\' IDENTIFIED BY \'root\' with grant option;"',
	} ->

	file_line { 'mysql_disable_bind':
		ensure => present,
		path   => '/etc/mysql/my.cnf',
		match  => '^bind-address           = 127.0.0.1',
		line   => '#bind-address           = 127.0.0.1',
	} ->

	file_line { 'mysql_custom_conf':
		ensure => present,
		path   => '/etc/mysql/my.cnf',
		match  => '^skip-external-locking',
		line   => 'skip-external-locking\nskip-innodb\ndefault-storage-engine = myisam\nlong_query_time = 1\nlog-bin = \/var\/log\/mysql\/mysql-bin.log\nsync_binlog = 1',
	} ->

	exec { 'mysql-restart':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service mysql restart",
	} ->

	# --- Amavisd-new, SpamAssassin, And Clamav

	package { 'amavisd-new':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'spamassassin':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'clamav':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'clamav-daemon':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'zoo':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'unzip':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'bzip2':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'arj':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'nomarch':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lzop':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'cabextract':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'apt-listchanges':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libnet-ldap-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libauthen-sasl-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'clamav-docs':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'daemon':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libio-string-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libio-socket-ssl-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libnet-ident-perl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'zip':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libnet-dns-perl ':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'postgrey':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	exec { 'spamassassin-disable':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "service spamassassin stop && systemctl disable spamassassin",
	} ->
	
	# --- XMPP
	package { 'git':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua5.1':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'liblua5.1-0-dev':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-filesystem':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libidn11-dev':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'libssl-dev':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-zlib':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-expat':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-event':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-bitop':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-socket ':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'lua-sec':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	package { 'luarocks':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	exec { 'xmpp-install':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "luarock install lpc && adduser --no-create-home --disabled-login --gecos 'Metronome' metronome",
	} ->

	
/*
	# git
	class { '::git':
		require => Exec['apt_upgrade'],
	} ->

	# unzip
	package { 'unzip':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	# curl
	package { 'curl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	

	# locales
	class { 'locales':
		default_locale  => 'fr_FR.UTF-8',
		locales         => [ 'fr_FR.UTF-8 UTF-8', 'en_US.UTF-8 UTF-8' ],
	} ->

	# timezone
	class { 'timezone':
		timezone => 'Europe/Paris',
	} ->

	

	package { 'openssl':
		ensure => 'installed',
		require => Exec['apt_upgrade'],
	} ->

	# php
	class { 'php7':
		require => Exec['apt_upgrade'],
	} ->

	# apache
	class { 'apache':
		#apache_name => 'apache2/testing',
		default_vhost => false,
		default_ssl_vhost => 
		false,
		docroot => '/var/www',
		error_documents => true,
		purge_configs => true,
		mpm_module => 'worker',
		sendfile => 'Off',
		#require => Exec['apt_upgrade'],
	} ->

	class { 'pagespeed': } ->

	# redis
	class { 'redis':
		bind => $::ipaddress,
	} ->

	# phpmyadmin
	class { 'phpmyadmin': } ->

	# remove useless packages
	exec { 'apt_remove':
		command => 'apt-get -y autoremove',
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
	}

	# nodejs
	#class { 'nodejs': } ->

	/*package { 'bower':
		ensure => 'present',
		provider => 'npm',
	}*/
/*
	class { 'apache::mod::headers': }
	class { 'apache::mod::cache': }
	class { 'apache::mod::disk_cache': }
	class { 'apache::mod::geoip': }
	class { 'apache::mod::rewrite': }
	class { 'apache::mod::expires': }
	class { 'apache::mod::vhost_alias': }
	class { 'apache::mod::include': }
	class { 'apache::mod::xsendfile': }
	class { 'apache::mod::fastcgi': }
	#class { 'apache::mod::pagespeed': }
	class { 'apache::mod::proxy': }
	class { 'apache::mod::proxy_http': }
	class { 'apache::mod::proxy_fcgi': }
	class { 'apache::mod::ssl': }
	apache::mod { 'http2': }
	#class { 'apache::mod::security': }*/
}