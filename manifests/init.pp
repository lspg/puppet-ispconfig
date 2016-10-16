class ispconfig (
	$hostname   = $ispconfig::params::hostname,
	$domain     = $ispconfig::params::domain,
	$admin_mail = $ispconfig::params::admin_mail,
) inherits ispconfig::params  {
	anchor { 'ispconfig::begin': } ->
		class { '::ispconfig::sources': } ->

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
		} ->

		class { '::ntp':
			package_ensure => installed,
			require => Exec['apt_upgrade'],
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

		class { '::ispconfig::postfix': } ->

		class { '::ispconfig::mysql': } ->

		class { '::ispconfig::amavis': } ->
		
		class { '::ispconfig::xmpp': } ->

		class { '::ispconfig::install': }
	anchor { 'ispconfig::end': }
}