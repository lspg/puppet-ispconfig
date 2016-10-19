class ispconfig::hhvm inherits ispconfig {
	# HHVM
	apt::key { 'hhvm':
		id      => '5a16e7281be7a449',
		server  => 'hkp://keyserver.ubuntu.com:80',
	} ->

	apt::source { "hhvm":
		location => 'http://dl.hhvm.com/debian',
		release  => "jessie",
		repos    => 'main',
		include  => {
			'deb' => true,
			'src' => true,
		},
	} ->

	apt::pin { 'hhvm':
		release  => "jessie",
		priority => 500,
		notify   => Exec['apt_update']
	} ->

	#exec { 'hhvm_repo':
	#	cwd => '/tmp',
	#	command => 'apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 && echo deb http://dl.hhvm.com/debian jessie main | sudo tee /etc/apt/sources.list.d/hhvm.list',
	#} ->

	#Exec['apt_update'] ->

	package { 'hhvm':
		ensure => installed,
		require => Apt::Pin['hhvm'],
	}
}