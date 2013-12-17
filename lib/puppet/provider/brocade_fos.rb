require 'puppet/provider'
require 'puppet/util/network_device'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
  attr_accessor :device

  def transport
    @device ||=Puppet::Util::NetworkDevice.current
  end
end
