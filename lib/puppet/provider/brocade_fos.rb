require 'puppet/provider'
require 'puppet_x/brocade/transport'

# This is the base Class of all prefetched brocade device providers
class Puppet::Provider::Brocade_fos < Puppet::Provider
  @doc = "Base class for all prefetched brocade providers. It creates device transport and manage configuration saving"
  attr_accessor :device, :transport

  def transport
    @transport ||= PuppetX::Brocade::Transport.new(Puppet[:certname])
    @transport.session
  end

  def cfg_save
    Puppet.debug("Saving changes by \"cfgsave\".")
    transport.command("cfgsave", :prompt => /Do/)
    response =  transport.command("yes", :noop => false)
    if response.match(/fail|err|not found|not an alias/)
      raise Puppet::Error, "Unable to save the Config because of the following issue: #{response}"
    else
      Puppet.debug("Successfully saved the Config")
    end
  end
end
