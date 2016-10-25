require 'facter'

Facter.add(:pure_ftpd_version) do
    confine :kernel  => :linux
    setcode do
        Facter::Util::Resolution.exec("V=$(apt-cache madison pure-ftpd-mysql | grep pure-ftpd-mysql | awk '{print $3}') && P=$(expr index \"$V\" -) && SH=${$V:0:$P-1} && echo ${SH}")
    end
end