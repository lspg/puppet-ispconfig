class ispconfig::preliminary inherits ispconfig {
	ensure_packages([
		'binutils',
		'curl',
		'git',
		'nano',
		'openssl',
		'openssh-server',
		'ssh',
		'sudo',
		'unzip',
	], {
		'ensure' => installed,
		'require' => Exec['apt_update'],
	})

	# CONFIGURE HOSTNAME
	class { 'hostname':
		hostname => $hostname,
		domain   => $domain,
	}

	# CHANGE DEFAULT SHELL
	exec { 'set-default-shell':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'echo "dash dash/sh boolean no" | debconf-set-selections && dpkg-reconfigure dash',
	}

	# locales
	class { 'locales':
		default_locale  => 'fr_FR.UTF-8',
		locales         => [ 'fr_FR.UTF-8 UTF-8', 'en_US.UTF-8 UTF-8' ],
	}

	# timezone
	class { 'timezone':
		timezone => 'Europe/Paris',
	}

	if ! str2bool("$is_virtual") {
		class { '::ntp':
			package_ensure => installed,
			require => Exec['apt_upgrade'],
		}
	}
}