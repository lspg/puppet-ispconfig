class ispconfig::xmpp inherits ispconfig {
	info('------------------------------------')
	info('--- Installing XMPP tchat server ---')
	info('------------------------------------')

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
	}
}