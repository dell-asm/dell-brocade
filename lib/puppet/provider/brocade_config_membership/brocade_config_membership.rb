require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'


Puppet::Type.type(:brocade_config_membership).provide(:brocade_config_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage addition and removal of zones to config."
  mk_resource_methods

  def create
    Puppet.debug("Puppet::Provider::brocade_config_membership: Adding Zone(s) #{@resource[:member_zone]} to Config #{@resource[:configname]}")
    response = @transport.command("cfgadd #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID_PARAMETERS)
      raise Puppet::Error, "Unable to add the Zone(s) #{@resource[:member_zone]} to Config #{@resource[:configname]}.Error: #{response}"
    elsif response.include? Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS
      Puppet.info("Zone(s) #{@resource[:member_zone]} already added to Config #{@resource[:configname]}")
    else
      cfg_save
    end
  end


  def destroy
    Puppet.debug("Puppet::Provider::brocade_config_membership: Removing Zone(s) #{@resource[:member_zone]} from Config #{@resource[:configname]}")
    response = @transport.command("cfgremove #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN ) || ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND )
      raise Puppet::Error, "Unable to remove the Zone(s) #{@resource[:member_zone]} from Config #{@resource[:configname]}. Error: #{response}"
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