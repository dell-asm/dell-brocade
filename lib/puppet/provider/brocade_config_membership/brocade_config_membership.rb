require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

def config_add_zone
  response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_ADD_MEMBER_COMMAND%[@resource[:configname],@resource[:member_zone]], :noop => false)
  if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase )
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_ERROR%[@resource[:member_zone],@resource[:configname],response]
  elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member_zone],@resource[:configname]])
  else
    cfg_save
  end
end

def config_remove_zone
  response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_REMOVE_MEMBER_COMMAND%[@resource[:configname],@resource[:member_zone]], :noop => false)
  if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG )
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DESTROY_ERROR%[@resource[:member_zone],@resource[:configname],response]
  elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member_zone],@resource[:configname]])
  else
    cfg_save
  end
end

Puppet::Type.type(:brocade_config_membership).provide(:brocade_config_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage addition and removal of zones to config."

  mk_resource_methods
  def create
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_DEBUG%[@resource[:member_zone],@resource[:configname]])
    config_add_zone
  end

  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DESTORY_DEBUG%[@resource[:member_zone],@resource[:configname]])
    config_remove_zone
  end

  def exists?
    self.device_transport
    response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_SHOW_COMMAND%[@resource[:configname]], :noop => false)
    if ("#{@resource[:ensure]}"== "present")
      if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
        Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_DOES_NOT_EXIST_INFO%[@resource[:configname]])
        return true
      end
      check_member_present(response)
    else
      if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
        Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_DOES_NOT_EXIST_INFO%[@resource[:configname]])
        return false
      end
      check_member_absent(response)
    end
  end

  def check_member_present(response)
    @resource[:member_zone].split(";").each do |member|
      if !(response.include? member)
        Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ADD_INFO%[member, @resource[:configname]])
        return false
      end
    end
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member_zone],@resource[:configname]])
    true
  end

  def check_member_absent(response)
    @resource[:member_zone].split(";").each do |member|
      if(response.include? member)
        Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_REMOVE_INFO%[member, @resource[:configname]])
        return true
      end
    end
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member_zone],@resource[:configname]])
    false
  end

end