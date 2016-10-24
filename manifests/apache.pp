class ispconfig::apache inherits ispconfig {
	ensure_packages([
		#'apache2',
		#'apache2.2-common',
		#'apache2-doc',
		#'apache2-mpm-prefork',
		#'apache2-suexec',
		#'apache2-utils',
		'imagemagick',
		#'libapache2-mod-fastcgi',
		#'libapache2-mod-fcgid',
		#'libapache2-mod-php5',
		#'libapache2-mod-python',
		#'libapache2-mod-security2',
		'libexpat1',
		'libruby',
		'ssl-cert',
		'mcrypt',
	], {
		'ensure' => 'installed',
	})

	# apache
	class { 'apache':
		#apache_name => 'apache2/testing',
		default_vhost => false,
		default_ssl_vhost => false,
		docroot => '/var/www',
		error_documents => true,
		purge_configs => true,
		mpm_module => 'worker',
		sendfile => 'Off',
		require => Exec['apt_update'],
	}

	apache::mod { 'auth_digest': }
	class { 'apache::mod::actions': }
	#class { 'apache::mod::alias': }
	#class { 'apache::mod::dav_fs': }
	#class { 'apache::mod::dav': }
	class { 'apache::mod::fastcgi': }
	class { 'apache::mod::include': }
	class { 'apache::mod::rewrite': }	
	class { 'apache::mod::ssl': }
	class { 'apache::mod::suexec': }
	#class { 'apache::mod::security2': }
	class { 'apache::mod::headers': }
	class { 'apache::mod::cache': }
	class { 'apache::mod::disk_cache': }
	class { 'apache::mod::geoip': }
	class { 'apache::mod::expires': }
	class { 'apache::mod::xsendfile': }
	#class { 'apache::mod::deflate': }
	class { 'pagespeed': }
	#class { 'apache::mod::vhost_alias': }
	#class { 'apache::mod::proxy': }
	#class { 'apache::mod::proxy_http': }
	#class { 'apache::mod::proxy_fcgi': }*/
	#apache::mod { 'http2': }

	if defined(Package['php5']) {
		file { '/etc/php5/apache2/conf.d/uploadprogress.ini':
			content => inline_template('extension=uploadprogress.so'),
			ensure => present,
			require => [Class['apache'], Package['php5']],
		}
	}

	file { '/etc/apache2/conf-available/httpoxy.conf':
		source => 'puppet:///modules/ispconfig/etc/apache2/conf-available/httpoxy.conf',
		ensure => present,
		require => [Class['apache'], Class['apache::mod::headers']],
	} ->

	exec { 'a2enconf-httpoxy':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "a2enconf httpoxy",
		require => File['/etc/apache2/conf-available/httpoxy.conf'],
	} ->

	exec { 'sed-mimetypes':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'sed -i "s/application\/x-ruby/#application\/x-ruby/g" /etc/mime.types',
		require => Class['apache'],
		notify  => Class['apache::service'],
	}
}