require 'puppet/provider'
require 'puppet/util/network_device'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
  @doc = "Base class for all prefetched brocade providers. It creates device transport and manage configuration saving"
  attr_accessor :device, :transport
  def device_transport
    #@device ||=Puppet::Util::NetworkDevice.current
    if Facter.value(:url) then
      Puppet.debug "Puppet::Util::NetworkDevice::Brocade_fos: connecting via facter url."
      @device ||= Puppet::Util::NetworkDevice::Brocade_fos::Device.new(Facter.value(:url))
    else
      @device ||= Puppet::Util::NetworkDevice.current
      raise Puppet::Error, "Puppet::Util::NetworkDevice::Brocade_fos: device not initialized #{caller.join("\n")}" unless @device
    end
    @transport = @device.transport
  end

  def cfg_save
    Puppet.debug("Saving changes by \"cfgsave\".")
    @transport.command("cfgsave", :prompt => /Do/)
    response =  @transport.command("yes", :noop => false)
    if response.match(/fail|err|not found|not an alias/)
      raise Puppet::Error, "Unable to save the Config because of the following issue: #{response}"
    else
      Puppet.debug("Successfully saved the Config")
    end
  end
end
