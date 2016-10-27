class ispconfig::clean inherits ispconfig {
	exec { 'apt_clean':
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		command => 'apt-get purge -y wget && apt-get autoremove -y && apt-get clean',
	} ->

	exec { 'post-install-clean':
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		command => 'rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/debconf/*-old /usr/share/doc/* /usr/share/man/*',
	} ->

	exec { 'post-install-clean':
		path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		command => 'cp -r /usr/share/locale/en\@* /tmp/ && rm -rf /usr/share/locale/* && mv /tmp/en\@* /usr/share/locale/',
	}
}