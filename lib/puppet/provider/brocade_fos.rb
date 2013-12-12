require 'puppet/provider'
require 'puppet/provider/confiner'
require 'puppet/util/network_device'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
attr_accessor :device

def transport
 Puppet.debug "Puppet::Util::NetworkDevice::Brocade_fos: connecting via url."
Puppet.debug "Puppet::Util::NetworkDevice::Brocade_fos:#{Puppet::Util::NetworkDevice.current}"      
@device ||=Puppet::Util::NetworkDevice.current
#@device ||= Puppet::Util::NetworkDevice::Brocade_fos::Device.new(Facter.value(:url))
#	@transport= @device.transport
end
end
