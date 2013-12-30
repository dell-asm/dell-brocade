require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods

 def create
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_CREATE_DEBUG%[@resource[:zonename],@resource[:member]])
    response =  @transport.command("zonecreate  #{@resource[:zonename]}, \"#{@resource[:member]}\"", :noop => false)
   if ((response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID)||(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_CREATE_ERROR%[@resource[:zonename],response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_EXIST_INFO%[@resource[:zonename]])
    else
      cfg_save
    end
  end



  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_DESTROY_DEBUG%[@resource[:zonename]])
    response = @transport.command("zonedelete  #{@resource[:zonename]}", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_REMOVED_INFO%[@resource[:zonename]])
    else
      cfg_save
    end
  end

  def exists?
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_EXISTS_DEBUG%[@resource[:zonename]])
    self.device_transport
    response =  @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if !response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST
      true
    else
      false
    end
  end

end
