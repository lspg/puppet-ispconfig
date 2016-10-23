class ispconfig::params {
	$apt_source     = 'http://httpredir.debian.org/debian'
	$hostname       = 'ispconfig'
	$domain         = 'local'
	$admin_mail		= "admin@${hostname}.${domain}"
	$mysql_root_pwd = 'root'
	$mailman_list_pwd = 'root'
}