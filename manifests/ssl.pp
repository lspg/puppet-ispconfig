class ispconfig::ssl inherits ispconfig {
	file { '/etc/ssl/private/':
		ensure => directory,
		owner => 'root',
		group => 'root',
	} ->

	/*class example($somevar) {
		file { "/etc/environment":
			content => inline_template("SOMEVAR=${somevar}")
		}
	}*/

	file { '/tmp/openssl.preseed':
		content => template('ispconfig/preseed/openssl.erb'),
		ensure => present,
	} ->

	exec { 'generate-certificates':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'openssl req -x509 -nodes -days 7300 -newkey rsa:4096 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -batch < /tmp/openssl.preseed',
		require => File['tmp/openssl.preseed'],
	} ->

	/*exec { 'generate-certificates':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		environment => [
			"KEY_COUNTRY=FR",
			"KEY_PROVINCE=Périgord",
			"KEY_CITY=Hautefort",
			"KEY_ORG=kctus MULTIMEDIA",
			"KEY_EMAIL=${admin_mail}",
			"KEY_CNAME=${hostname}.${domain}"
		],
		command => 'openssl req -x509 -nodes -days 7300 -newkey rsa:4096 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -batch',
	} ->*/

	file { '/etc/ssl/private/pure-ftpd.pem':
		ensure => present,
		owner => 'root',
		group => 'root',
		mode => '0600',
		notify => Service['pure-ftpd-mysql'],
	}
}