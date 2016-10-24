class ispconfig::ispconfig inherits ispconfig {
	exec { 'ispconfig-download':
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz -O /tmp/ispconfig.tar.gz',
		require => Package['wget'],
	} ->

	exec { 'ispconfig-uncompress':
		cwd => '/tmp',
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
		command => 'tar xfz ispconfig.tar.gz',
	} ->
}