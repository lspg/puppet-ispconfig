class ispconfig::security inherits ispconfig {
	ensure_packages([
		'fail2ban',
		'ufw',
	], {
		'ensure' => 'installed',
		'require' => Exec['apt_update'],
	})

	file_line {'postfix-sasl-ignoreregex':
		line      => 'ignoreregex =',
		path      => '/etc/fail2ban/filter.d/postfix-sasl.conf',
		#after    => undef,
		ensure   => 'present',
		#match    => undef, # /.*match/
		#multiple => undef, # 'true' or 'false'
		#name     => undef,
		#replace  => true, # 'true' or 'false'
	} ->

	exec { 'fail2ban-restart':
		path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
		command => 'service fail2ban restart',
	}
}