require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

  mk_resource_methods
  def initialize_resources
    @ZONE_NAME=@resource[:zonename]
    @MEMBER=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_CREATE_DEBUG%[@ZONE_NAME,@MEMBER])
    response =  @transport.command(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@ZONE_NAME,@MEMBER], :noop => false)
    if ((response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase)||(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_CREATE_ERROR%[@ZONE_NAME,response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_EXIST_INFO%[@ZONE_NAME])
    else
      cfg_save
    end
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_DESTROY_DEBUG%[@ZONE_NAME])
    response = @transport.command(Puppet::Provider::Brocade_commands::ZONE_DELETE_COMMAND%[@ZONE_NAME], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_REMOVED_INFO%[@ZONE_NAME])
    else
      cfg_save
    end
  end

  def exists?
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_EXISTS_DEBUG%[@ZONE_NAME])
    self.device_transport
    response =  @transport.command(Puppet::Provider::Brocade_commands::ZONE_SHOW_COMMAND%[@ZONE_NAME], :noop => false)
    if !response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST
    true
    else
    false
    end
  end

end
