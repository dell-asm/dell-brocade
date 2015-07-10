require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

def check_error_cond(response)
  return ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include?Puppet::Provider::Brocade_responses::RESPONSE_INVALID.downcase)  || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
end

def create_zone_membership

  response = String.new("")
  response = transport.command(Puppet::Provider::Brocade_commands::ZONE_ADD_MEMBER_COMMAND%[@zone_name,@member_name], :noop => false)
  if check_error_cond(response)
    raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_ERROR%[@member_name,@zone_name,response]
  elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
    Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_name,@zone_name])
  else
    cfg_save
  end
  transport.close
end

def destroy_zone_membership
  response = String.new("")
  response =  transport.command(Puppet::Provider::Brocade_commands::ZONE_REMOVE_MEMBER_COMMAND%[@zone_name,@member_name], :noop => false)
  if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include?Puppet::Provider::Brocade_responses::RESPONSE_INVALID.downcase ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG )
    raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_DESTROY_ERROR%[@member_name,@zone_name,response]
  elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
    Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_name,@zone_name])
  else
    cfg_save
  end
  transport.close
end

def zone_membership_response_exists?(response)
  if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
    Puppet.info(Puppet::Provider::Brocade_messages::ZONE_DOES_NOT_EXIST_INFO%[@zone_name])
  return true
  else
  return false
  end
end

def zone_membership_response_includes_wwpn?(response)
  return_value = true
  @member_name.split(";").each do |wwpn|
    if !(response.include? wwpn)
    return_value = false
    end
  end
  return return_value
end

def zone_membership_exists_when_ensure_present(response)
  if (zone_membership_response_exists?(response))
  return true
  end
  if !(zone_membership_response_includes_wwpn?(response))
  return false
  end
  Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_name,@zone_name])
  return true

end

def zone_membership_exists_when_ensure_absent(response)
  if (zone_membership_response_exists?(response))
  return false
  end
  if (zone_membership_response_includes_wwpn?(response))
  return true
  end
  Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_name,@zone_name])
  return false

end

Puppet::Type.type(:brocade_zone_membership).provide(:brocade_zone_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone member addition and removal from/to zone."

  mk_resource_methods
  def initialize_resources
    @zone_name=@resource[:zonename]
    @member_name=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_DEBUG%[@zone_name,@member_name])
    create_zone_membership
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_DESTROY_DEBUG%[@zone_name,@member_name])
    destroy_zone_membership
  end

  def exists?
    initialize_resources
    response = transport.command(Puppet::Provider::Brocade_commands::ZONE_SHOW_COMMAND%[@zone_name], :noop => false)
    if("#{@resource[:ensure]}"== "present")
      return zone_membership_exists_when_ensure_present(response)
    else
      return zone_membership_exists_when_ensure_absent(response)
    end
  end
end

