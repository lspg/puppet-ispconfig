require 'facter'

Facter.add(:pure_ftpd_version) do
    confine :kernel  => :linux
    setcode do
        Facter::Util::Resolution.exec("apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}'")
    end
end