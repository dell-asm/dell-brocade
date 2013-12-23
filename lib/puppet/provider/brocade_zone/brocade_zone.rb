require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods

 def create
    Puppet.debug("Puppet::Provider::brocade_zone: A Brocade zone with zonename: #{@resource[:zonename]}, zonemember:  #{@resource[:member]} is being added.")
    response =  @transport.command("zonecreate  #{@resource[:zonename]},  #{@resource[:member]}", :noop => false)
    if !response.include? "duplicate name"
      cfg_save
    end
  end



  def destroy
    Puppet.debug("Puppet::Provider::brocade_zone: A Brocade zone with zonename: #{@resource[:zonename]} is being deleted.")
    response = @transport.command("zonedelete  #{@resource[:zonename]}", :noop => false)
    if !response.include? "not found"
      cfg_save
    end
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_zone: Verifying whether or not a Brocade zone with zonename: #{@resource[:zonename]} exists.")
    self.device_transport
    response =  @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if !response.include? "does not exist."
      true
    else
      false
    end
  end

end
