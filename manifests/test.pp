require 'facter'

Facter.add(:my_script_value) do
    confine :kernel  => :linux
    setcode do
        Facter::Util::Resolution.exec("apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}'")
    end
end

class ispconfig::test inherits ispconfig {

	#$myversion = generate ("/bin/bash", "-c", "apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}'")
	warning($::my_script_value)

	package { 'gawk':
		ensure => latest,
		#require => Exec['apt_update'],
	} ->

	file { '/tmp/pure-ftpd-mysql':
		ensure => directory,
		owner => 'root',
		group => 'root',
	} ->

	file { '/tmp/pure-ftpd-mysql/$myversion':
		ensure => directory,
		owner => 'root',
		group => 'root',
	}
	
	#apt-cache madison pure-ftpd-mysql | awk '{print $3}'
	#TEST=$(apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}')
}