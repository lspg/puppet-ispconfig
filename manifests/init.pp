class ispconfig (
	$apt_source = $ispconfig::params::apt_source,
	$hostname   = $ispconfig::params::hostname,
	$domain     = $ispconfig::params::domain,
	$admin_mail = $ispconfig::params::admin_mail,
	$mysql_root_pwd = $ispconfig::params::mysql_root_pwd,
	$mailman_list_pwd = $ispconfig::params::mailman_list_pwd,
) inherits ispconfig::params  {
	#notice($::trusted['certname'])
	notice($::virtual)
	#notice($::osfamily)
	#notice($::trusted)
	anchor { 'ispconfig::begin': } ->
		#class { '::ispconfig::sources': } ->
		#class { '::ispconfig::preliminary': } ->
		#class { '::ispconfig::mysql': } ->
		#class { '::ispconfig::postfix': } ->
		#class { '::ispconfig::spamantiv': } ->
		#class { '::ispconfig::xmpp': } ->
		#class { '::ispconfig::php': } ->
		#class { '::ispconfig::apache': } ->
		#class { '::ispconfig::phpmyadmin': } ->
		#class { '::ispconfig::hhvm': } ->
		#class { '::ispconfig::letsencrypt': } ->
		#class { '::ispconfig::mailman::install': } ->
		#class { 'redis': bind => $::ipaddress } ->

		class { '::ispconfig::ftp': } ->
		#class { '::ispconfig::dns': } ->
		#class { '::ispconfig::statlog': } ->
		#class { '::ispconfig::jailkit': } ->
		#class { '::ispconfig::security': } ->
		#class { '::ispconfig::rainloop': } ->

		exec { 'apt_remove':
			command => 'apt-get -y autoremove',
			path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		} ->
	anchor { 'ispconfig::end': }
}