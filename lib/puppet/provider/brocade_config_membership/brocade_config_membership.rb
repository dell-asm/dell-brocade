require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'


Puppet::Type.type(:brocade_config_membership).provide(:brocade_config_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DOC
  mk_resource_methods

  def create
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_DEBUG%[@resource[:member_zone],@resource[:configname]])
    response = @transport.command("cfgadd #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID_PARAMETERS)
      raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_CREATE_ERROR%[@resource[:member_zone],@resource[:configname],response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member_zone],@resource[:configname]])
    else
      cfg_save
    end
  end


  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_DESTORY_DEBUG%[@resource[:member_zone],@resource[:configname]])
    response = @transport.command("cfgremove #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND )
      raise Puppet::Error, Puppet::Provider::Brocade_responses::CONFIG_MEMBERSHIP_DESTROY_ERROR%[@resource[:member_zone],@resource[:configname],response]
	elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
	  Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member_zone],@resource[:configname]])
    else 
      cfg_save
    end
  end


  def exists?
    self.device_transport
    if "#{@resource[:ensure]}" == "present" 
      false
    else
      true
    end
  end

end