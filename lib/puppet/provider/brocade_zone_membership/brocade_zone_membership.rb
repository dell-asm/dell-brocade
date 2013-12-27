require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'


Puppet::Type.type(:brocade_zone_membership).provide(:brocade_zone_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone member addition and removal from/to zone."

  mk_resource_methods
  def create
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_DEBUG%[@resource[:member],@resource[:zonename]])
    response = String.new("")
    response = @transport.command("zoneadd #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID)  || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_ERROR%[@resource[:member],@resource[:zonename],response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member],@resource[:zonename]])
    else
      cfg_save
    end
  end

  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_DESTROY_DEBUG%[@resource[:member],@resource[:zonename]])

    response = String.new("")
    response =  @transport.command("zoneremove #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      raise Puppet::Error, Puppet::Provider::Brocade_responses::ZONE_MEMBERSHIP_DESTROY_ERROR%[@resource[:member],@resource[:zonename],response]
	elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
	  Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member],@resource[:zonename]])
    else 
      cfg_save
end
end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_zone_membership: Verifying whether or not the Brocade zone with zonename: #{@resource[:zonename]} #{@resource[:member]} exists.")
    self.device_transport
    if "#{@resource[:ensure]}" == "present" 
      false
    else
      true
end
end
end
