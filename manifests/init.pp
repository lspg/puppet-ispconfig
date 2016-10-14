class ispconfig (
	$hostname   = $ispconfig::params::hostname,
	$domain     = $ispconfig::params::domain,
	$admin_mail = $ispconfig::params::admin_mail,
) inherits ispconfig::params  {
	anchor { 'ispconfig::begin': } ->
		class { '::ispconfig::sources': } ->
		class { '::ispconfig::install': }
	anchor { 'ispconfig::end': }
}