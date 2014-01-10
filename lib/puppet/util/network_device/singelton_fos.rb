require 'puppet/util/network_device/brocade_fos/device'

#Create Singleton cache to store the Device
class Puppet::Util::NetworkDevice::Singelton_fos
  def self.lookup(url)
    @map ||= {}
    return @map[url] if @map[url]
    @map[url] = Puppet::Util::NetworkDevice::Brocade_fos::Device.new(url).init
    return @map[url]
  end

  def self.clear
    @map.clear
  end
end
