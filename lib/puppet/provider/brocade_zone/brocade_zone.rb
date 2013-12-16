require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_zone).provide(:brocade_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods


 def create
    Puppet.debug("Puppet::Provider::brocade_zone: creating Brocade zone for #{@resource[:zonename]} member  #{@resource[:member]}. \n")
    self.transport
    response = String.new("")
    response =  @device.transport.command("zonecreate  #{@resource[:zonename]},  #{@resource[:member]}", :noop => false)
    Puppet.debug("Puppet::Provider::brocade_zone: response #{response}. \n")
    if !response.include? "duplicate name" 
      @device.transport.command("cfgsave", :prompt => /Do/)
      @device.transport.command("yes", :noop => false)
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_zone: destroying Brocade zone #{@resource[:zonename]}.")
    self.transport
    response = String.new("")
    response = @device.transport.command("zonedelete  #{@resource[:zonename]}", :noop => false)
    if !response.include? "not found"
       @device.transport.command("cfgsave", :prompt => /Do/)
       @device.transport.command("yes", :noop => false)
    end
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_zone: checking existence of Brocade zone #{@resource[:zonename]}.")
    self.transport
    response = String.new("")
    response =  @device.transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if !response.include? "does not exist."
    true
    else
      false
    end
  end

end

