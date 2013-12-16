require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_zone).provide(:brocade_fos, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

 mk_resource_methods
# def self.instances
#    Puppet.debug("Puppet::Provider::brocade_zone: got to self.instances.")
   #: @transport = @device.transport
#	self.transport
#	zones = Hash.new
#	Puppet.debug("Zones:#{zones}")
#   zones = @device.transport.command("zoneshow", :noop => false)
#	Puppet.debug("Zones:#{zones}")
# end

  def self.prefetch(resources)
    Puppet.debug("Puppet::Provider::brocade_zone: Got to self.prefetch.")
    # Iterate instances and match provider where relevant.
#    instances.each do |prov|
#      Puppet.debug("Prov.name = #{resources[prov.name]}. ")
#      if resource = resources[prov.name]
#        resource.provider = prov
#      end
#    end
#    resources.each do |name, resource|
#      device = Puppet::Util::NetworkDevice.current
#      if result = lookup(device, name)
#        resource.provider = new(device, result)
#      else
#        resource.provider = new(:ensure => :absent)
#        resource.provider = new(device)
#      end
#    end
  end

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
    true
  end

end

