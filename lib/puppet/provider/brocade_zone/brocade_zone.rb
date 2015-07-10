require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

  mk_resource_methods
  def initialize_resources
    @zone_name=@resource[:zonename]
    @member_name=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_CREATE_DEBUG%[@zone_name,@member_name])
    response =  transport.command(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@zone_name,@member_name], :noop => false)
    if ((response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase)||(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_CREATE_ERROR%[@zone_name,response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_EXIST_INFO%[@zone_name])
    else
      cfg_save
    end
    transport.close
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_DESTROY_DEBUG%[@zone_name])
    response = transport.command(Puppet::Provider::Brocade_commands::ZONE_DELETE_COMMAND%[@zone_name], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_ALREADY_REMOVED_INFO%[@zone_name])
    else
      cfg_save
    end
    transport.close
  end

  def exists?
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_EXISTS_DEBUG%[@zone_name])
    response =  transport.command("zoneshow #{@zone_name}", :noop => false)
    !response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST
  end

end
