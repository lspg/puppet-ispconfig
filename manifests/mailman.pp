class ispconfig::mailman inherits ispconfig {
}

class ispconfig::mailman::install inherits ispconfig {
	package { 'mailman':
		responsefile => "/tmp/mailman.seeds",
		ensure       => installed,
	}
}

class ispconfig::mailman::config inherits ispconfig {
	file { '/tmp/newlist_mailman.preseed':
		content => template('ispconfig/preseed/newlist_mailman.erb'),
		ensure => present,
	} ->

	exec { 'newlist_mailman':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'newlist mailman < /tmp/newlist_mailman.preseed',
		require => File['/tmp/newlist_mailman.preseed'],
	} ->

	file { '/etc/aliases':
		source => 'puppet:///modules/ispconfig/etc/aliases',
		ensure => present,
	} ->

	exec { 'newaliases':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'newaliases',
		require => File['/tmp/newlist_mailman.preseed'],
		notify => Service['postfix'],
	}
}