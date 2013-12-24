require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_messages'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods

 def create
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MSG_01%[@resource[:zonename],@resource[:member]])
    response =  @transport.command("zonecreate  #{@resource[:zonename]}, \"#{@resource[:member]}\"", :noop => false)
    if !response.include? Puppet::Provider::Brocade_messages::RESPONSE_ZONE_03
      cfg_save
    end
  end



  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MSG_02%[@resource[:zonename]])
    response = @transport.command("zonedelete  #{@resource[:zonename]}", :noop => false)
    if !response.include? Puppet::Provider::Brocade_messages::RESPONSE_ZONE_01
      cfg_save
    end
  end

  def exists?
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MSG_03%[@resource[:zonename]])
    self.device_transport
    response =  @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if !response.include? Puppet::Provider::Brocade_messages::RESPONSE_ZONE_02
      true
    else
      false
    end
  end

end
