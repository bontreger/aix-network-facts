### Interfaces.rb 
###
### A Facter custom fact for finding ip addresses of all interfaces on an AIX machine
###
### New Facts:
### interface_count
###   An integer count of the number of interfaces on the system, ignoring loopbacks
###
### interface_names
###   A comma separated list of the interface names available on the system
###
### ipaddress_{interface_name}
###   For every interface name, a new fact with the ipv4 address of that interface is created

require 'facter'

interface_count = Facter::Util::Resolution.exec("ifconfig -l | wc | awk '{print $2}'")
interface_count = interface_count.to_i - Facter::Util::Resolution.exec("ifconfig -a | grep 127. | wc | awk '{priint $1}'").to_i

interface_names = Facter::Util::Resolution.exec("ifconfig -l")
interface_names_array = interface_names.split()
interface_names = interface_names_array.join(',')

Facter.add(:interface_count) do
  setcode do
    interface_count
  end
end

Facter.add(:interface_names) do
  setcode do
    interface_names
  end
end

interface_names_array.each do |interface|
  ipaddr = Facter::Util::Resolution.exec("ifconfig #{interface} | grep 'inet\s' | awk '{print $2}'")
  Facter.add("ipaddress_#{interface}") do
    setcode do
      ipaddr
    end
  end
end
