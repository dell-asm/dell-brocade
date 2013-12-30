require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

def check_error_cond(response)
return ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID)  || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
end

  def create_local
    response = String.new("")
    response = @transport.command("zoneadd #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    if check_error_cond(response)
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_ERROR%[@resource[:member],@resource[:zonename],response]
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_EXIST_INFO%[@resource[:member],@resource[:zonename]])
    else
      cfg_save
    end
  end

  def destroy_local
    response = String.new("")
    response =  @transport.command("zoneremove #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND )
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_DESTROY_ERROR%[@resource[:member],@resource[:zonename],response]
        elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN )
          Puppet.info(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_ALREADY_REMOVED_INFO%[@resource[:member],@resource[:zonename]])
    else
      cfg_save
        end
	end
	
Puppet::Type.type(:brocade_zone_membership).provide(:brocade_zone_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone member addition and removal from/to zone."

  mk_resource_methods

	def create
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_CREATE_DEBUG%[@resource[:zonename],@resource[:member]])
		create_local
	end 

    def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::ZONE_MEMBERSHIP_DESTROY_DEBUG%[@resource[:zonename],@resource[:member]])
		destroy_local
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

