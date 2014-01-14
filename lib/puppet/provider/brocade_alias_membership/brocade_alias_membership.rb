require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

def alias_membership_response_exists? (response)
  if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
    Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@alias_name])
  return true
  else
  return false
  end
end

def alias_membership_response_includes_wwpn? (response)
  return_value = true
  @member_name.split(";").each do |wwpn|
    if !(response.include? wwpn)
    return_value = false
    end
  end
  return return_value
end

def alias_membership_exists_when_ensure_present(response)
  if (alias_membership_response_exists?(response))
  return true
  end
  if !(alias_membership_response_includes_wwpn?(response))
  return false
  end
  Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_name,@alias_name])
  return true

end

def alias_membership_exists_when_ensure_absent(response)
  if (alias_membership_response_exists?(response))
  return false
  end
  if (alias_membership_response_includes_wwpn?(response))
  return true
  end
  Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_name,@alias_name])
  return false

end

Puppet::Type.type(:brocade_alias_membership).provide(:brocade_alias_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade alias members addition and removal."

  mk_resource_methods
  def initialize_resources
    @alias_name=@resource[:alias_name]
    @member_name=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_DEBUG%[@alias_name,@member_name])
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@alias_name,@member_name], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include?(Puppet::Provider::Brocade_responses::RESPONSE_INVALID.downcase))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_ERROR%[@alias_name,@alias_name,response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_name,@alias_name])
    else
      cfg_save
    end
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_DESTROY_DEBUG%[@alias_name,@member_name])
    response =  @transport.command(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@alias_name,@member_name], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_DESTROY_ERROR%[@member_name,@alias_name,response]
    elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_name,@alias_name])
    else
      cfg_save
    end
  end

  def exists?
    initialize_resources
    self.device_transport
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@alias_name], :noop => false)
    if("#{@resource[:ensure]}"== "present")
      return alias_membership_exists_when_ensure_present(response)
    else
      return alias_membership_exists_when_ensure_absent(response)
    end
  end
end