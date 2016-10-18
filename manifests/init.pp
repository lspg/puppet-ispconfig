class ispconfig (
	$apt_source = $ispconfig::params::apt_source,
	$hostname   = $ispconfig::params::hostname,
	$domain     = $ispconfig::params::domain,
	$admin_mail = $ispconfig::params::admin_mail,
	$mysql_root_pwd = $ispconfig::params::mysql_root_pwd,
) inherits ispconfig::params  {
	notice($::trusted['certname'])
	notice($::virtual)
	notice($::osfamily)
	notice($::trusted)
	/*anchor { 'ispconfig::begin': } ->
		class { '::ispconfig::sources': } ->
		class { '::ispconfig::preliminary': } ->
		class { '::ispconfig::mysql': } ->
		#class { '::ispconfig::postfix': } ->
		#class { '::ispconfig::php': } ->
		#class { '::ispconfig::apache': } ->
		#class { 'phpmyadmin': } ->
		#class { '::ispconfig::amavis': } ->
		#class { '::ispconfig::xmpp': } ->
		#class { 'redis': bind => $::ipaddress } ->
		exec { 'apt_remove':
			command => 'apt-get -y autoremove',
			path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		} ->
	anchor { 'ispconfig::end': }*/
}