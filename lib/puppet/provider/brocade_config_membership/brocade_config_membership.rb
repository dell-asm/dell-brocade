require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_config_membership).provide(:brocade_config_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage addition and removal of zones to config."
  mk_resource_methods

  def create
    Puppet.debug("Adding Zone(s) #{@resource[:member_zone]} to Config #{@resource[:configname]}")
    response = @transport.command("cfgadd #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if ( response.include? "already contains" ) || ( response.include? "not found" ) || ( response.include? "Invalid Parameters")
      raise Puppet::Error, "Unable to add the Zone(s) #{@resource[:member_zone]} to Config #{@resource[:configname]}.Error: #{response}"
    else
      cfg_save
    end
  end


  def destroy
    Puppet.debug("Removing Zone(s) #{@resource[:member_zone]} from Config #{@resource[:configname]}")
    response = @transport.command("cfgremove #{@resource[:configname]}, \"#{@resource[:member_zone]}\"", :noop => false)
    if (response.include? "is not in") || ( response.include? "not found" )
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
