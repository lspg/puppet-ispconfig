class ispconfig::xmpp inherits ispconfig {
	ensure_packages([
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

	if ! defined(Package['git']) {
		package { 'bzip2':
			ensure => latest,
			require => Exec['apt_update'],
		}
	}
	
	exec { 'xmpp-install':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => "luarocks install lpc && adduser --no-create-home --disabled-login --gecos 'Metronome' metronome",
		require => Package['luarocks'],
	}

	/*user { 'metronome':
		ensure => present,
		home => false,
		managehome => false,
		shell => '/bin/false',
		comment => 'Metronome',
	}*/

	vcsrepo { '/opt/metronome':
		ensure   => present,
		provider => git,
		source   => 'https://github.com/maranda/metronome.git',
	} ->

	exec { 'metronome-config':
		cwd     => '/opt/metronome',
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => '/opt/metronome/./configure --ostype=debian --prefix=/usr && make && make install',
		require => VcsRepo['/opt/metronome'],
	}
}