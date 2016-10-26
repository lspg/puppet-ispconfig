class ispconfig::php inherits ispconfig {
	ensure_packages([
		'imagemagick',
		'libexpat1',
		'ssl-cert',
		'memcached',
		'mcrypt',
		'php-auth',
		'php-pear',
		'php-services-json',
	], {
		'ensure' => 'installed',
	})

	ensure_packages([
		'php5',
		'php5-cgi',
		'php5-cli',
		'php5-common',
		'php5-curl',
		'php5-dev',
		'php5-fpm',
		'php5-gd',
		'php5-imagick',
		'php5-imap',
		'php5-intl',
		'php5-mcrypt',
		'php5-memcache',
		'php5-memcached',
		'php5-mysql',
		'php5-pspell',
		'php5-recode',
		'php5-snmp',
		'php5-sqlite',
		'php5-tidy',
		'php5-xcache',
		'php5-xmlrpc',
		'php5-xsl',
	], {
		'ensure' => 'installed',
	})

	ensure_packages([
		'php7.0',
		'php7.0-cgi',
		'php7.0-cli',
		'php7.0-common',
		'php7.0-curl',
		'php7.0-dev',
		'php7.0-fpm',
		'php7.0-gd',
		'php7.0-imagick',
		'php7.0-imap',
		'php7.0-intl',
		'php7.0-mcrypt',
		'php7.0-memcached',
		'php7.0-mysql',
		'php7.0-pspell',
		'php7.0-recode',
		'php7.0-snmp',
		'php7.0-sqlite3',
		'php7.0-tidy',
		'php7.0-xcache',
		'php7.0-xmlrpc',
		'php7.0-xsl',
	], {
		'ensure' => 'installed',
	})
}