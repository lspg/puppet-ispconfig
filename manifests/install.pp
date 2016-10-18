class ispconfig::install inherits ispconfig {
	# CONFIGURE HOSTNAME
	class { 'hostname':
		hostname => $hostname,
		domain   => $domain,
	}

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