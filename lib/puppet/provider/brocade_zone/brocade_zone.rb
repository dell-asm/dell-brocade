require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods


 def create
    Puppet.debug("Puppet::Provider::brocade_zone: Creating Brocade zone with zonename: #{@resource[:zonename]}, zonemember:  #{@resource[:member]}.")
    response = String.new("")
    response =  @transport.command("zonecreate  #{@resource[:zonename]},  #{@resource[:member]}", :noop => false)
    if !response.include? "duplicate name" 
      @transport.command("cfgsave", :prompt => /Do/)
      @transport.command("yes", :noop => false)
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_zone: Destroying Brocade zone with zonename: #{@resource[:zonename]}.")
    response = String.new("")
    response = @transport.command("zonedelete  #{@resource[:zonename]}", :noop => false)
    if !response.include? "not found"
       @transport.command("cfgsave", :prompt => /Do/)
       @transport.command("yes", :noop => false)
    end
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_zone: Checking existence of Brocade zone with zonename: #{@resource[:zonename]}.")
    self.device_transport
    response = String.new("")
    response =  @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if !response.include? "does not exist."
    true
    else
      false
    end
  end

end

