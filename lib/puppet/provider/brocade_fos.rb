require 'puppet/provider'
require 'puppet/util/network_device'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
  attr_accessor :device, :transport

  def device_transport
    @device ||=Puppet::Util::NetworkDevice.current
    @transport = @device.transport
  end

  def cfg_save
    Puppet.debug("Saving changes by \"cfgsave\".")
    @transport.command("cfgsave", :prompt => /Do/)
    response =  @transport.command("yes", :noop => false)
    if response.match(/fail|err|not found|not an alias/)
      raise Puppet::Error, "Unable to save the Config #{@resource[:configname]} because of the following issue: #{response}"
    else
      Puppet.debug("Successfully saved the config #{@resource[:configname]}")
    end
  end
end
