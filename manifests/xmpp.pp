class ispconfig::xmpp inherits ispconfig {
	notice('------------------------------------')
	notice('--- Installing XMPP tchat server ---')
	notice('------------------------------------')

	ensure_packages([
		'git',
		'libidn11-dev',
		'liblua5.1-0-dev',
		'libssl-dev',
		'lua5.1',
		'lua-bitop',
		'lua-event',
		'lua-expat',
		'lua-filesystem',
		'lua-sec',
		'lua-socket',
		'lua-zlib',
		'luarocks',
	], {
		'ensure' => 'installed',
	})
	
	exec { 'xmpp-install':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "luarocks install lpc && adduser --no-create-home --disabled-login --gecos 'Metronome' metronome",
		require => Package['luarocks'],
	}
}