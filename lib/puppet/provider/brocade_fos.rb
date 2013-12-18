require 'puppet/provider'
require 'puppet/util/network_device'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
  attr_accessor :device, :transport

  def device_transport
    @device ||=Puppet::Util::NetworkDevice.current
    @transport = @device.transport
  end
end
