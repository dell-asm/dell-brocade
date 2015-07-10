require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

def config_add_zone
  response = transport.command(Puppet::Provider::Brocade_commands::CONFIG_ADD_MEMBER_COMMAND%[@config_name,@member_zone], :noop => false)
  if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase )
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_ERROR%[@member_zone,@config_name,response]
  elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_zone,@config_name])
  else
    cfg_save
  end
end

def config_remove_zone
  response = transport.command(Puppet::Provider::Brocade_commands::CONFIG_REMOVE_MEMBER_COMMAND%[@config_name,@member_zone], :noop => false)
  if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG )
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DESTROY_ERROR%[@member_zone,@config_name,response]
  elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_zone,@config_name])
  else
    cfg_save
  end
end

def check_member_present(response)
  initialize_resources
  @member_zone.split(";").each do |member|
    if !(response.include? member)
      Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ADD_INFO%[member, @config_name])
    return false
    end
  end
  transport.close
  Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@member_zone,@config_name])
  true
end

def check_member_absent(response)
  initialize_resources
  @member_zone.split(";").each do |member|
    if(response.include? member)
      Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_REMOVE_INFO%[member, @config_name])
    return true
    end
  end
  transport.close
  Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@member_zone,@config_name])
  false
end

def config_membership_response_exists?(response)
  if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_DOES_NOT_EXIST_INFO%[@config_name])
  return true
  else
  return false
  end
end

Puppet::Type.type(:brocade_config_membership).provide(:brocade_config_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage addition and removal of zones to config."

  mk_resource_methods
  def initialize_resources
    @config_name=@resource[:configname]
    @member_zone=@resource[:member_zone]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_DEBUG%[@member_zone,@config_name])
    config_add_zone
    transport.close
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DESTORY_DEBUG%[@member_zone,@config_name])
    config_remove_zone
    transport.close
  end

  def exists?
    initialize_resources
    response = transport.command(Puppet::Provider::Brocade_commands::CONFIG_SHOW_COMMAND%[@config_name], :noop => false)
    if ("#{@resource[:ensure]}"== "present")
      if (config_membership_response_exists?(response))
      return true
      end
      check_member_present(response)
    else
      if (config_membership_response_exists?(response))
      return false
      end
      check_member_absent(response)
    end
  end

end