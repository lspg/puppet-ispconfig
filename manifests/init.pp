class ispconfig (
	$hostname   = $ispconfig::params::hostname,
	$domain     = $ispconfig::params::domain,
	$admin_mail = $ispconfig::params::admin_mail,
) inherits ispconfig::params  {
	anchor { 'ispconfig::begin': } ->
		class { '::ispconfig::sources': } ->
		class { '::ispconfig::preliminary': } ->
		class { '::ispconfig::postfix': } ->
		class { '::ispconfig::mysql': } ->
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
	anchor { 'ispconfig::end': }
}