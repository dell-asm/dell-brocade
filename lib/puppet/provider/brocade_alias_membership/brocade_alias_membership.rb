require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

Puppet::Type.type(:brocade_alias_membership).provide(:brocade_alias_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade alias members addition and removal."

  mk_resource_methods
  def initialize_resources
    @ALIAS_NAME=@resource[:alias_name]
    @MEMBER_NAME=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_DEBUG%[@ALIAS_NAME,@MEMBER_NAME])
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@resource[:alias_name],@resource[:member]], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include?(Puppet::Provider::Brocade_responses::RESPONSE_INVALID.downcase))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_ERROR%[@ALIAS_NAME,@resource[:alias_name],response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@MEMBER_NAME,@ALIAS_NAME])
    else
      cfg_save
    end
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_DESTROY_DEBUG%[@ALIAS_NAME,@MEMBER_NAME])
    response =  @transport.command(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@ALIAS_NAME,@MEMBER_NAME], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_DESTROY_ERROR%[@MEMBER_NAME,@ALIAS_NAME,response]
    elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@MEMBER_NAME,@ALIAS_NAME])
    else
      cfg_save
    end
  end

  def get_exists_when_ensure_present(response)
    if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@resource[:alias_name]])
    return true
    elsif
    @resource[:member].split(";").each do |wwpn|
    if !(response.include? wwpn)
    return false
    end
    end
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member],@resource[:alias_name]])
    return true
    end
  end

  def get_exists_when_ensure_absent(response)
    if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@resource[:alias_name]])
    return false
    elsif
    @resource[:member].split(";").each do |wwpn|
    if (response.include? wwpn)
    return true
    end
    end
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member],@resource[:alias_name]])
    return false
    end
  end

  def exists?
    initialize_resources
    self.device_transport
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@ALIAS_NAME], :noop => false)
    if("#{@resource[:ensure]}"== "present")
      return get_exists_when_ensure_present(response)
    else
      return get_exists_when_ensure_absent(response)
    end
  end
end