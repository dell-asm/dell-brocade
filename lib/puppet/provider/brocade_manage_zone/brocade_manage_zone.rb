require 'puppet/provider/brocade_fos'
require 'puppet/provider'

Puppet::Type.type(:brocade_manage_zone).provide(:brocade_manage_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone creation, modification and deletion."

mk_resource_methods

 def create
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Adding Member to Zone with zonename: #{@resource[:zonename]}, zonemember: #{@resource[:member]}, ConfigName: #{@resource[:configname]}.")
    response = String.new("")
    response = @device.transport.command("zoneadd #{@resource[:zonename]},#{@resource[:member]}", :noop => false)
    if response.include? "duplicate name" 
      @device.transport.command("cfgsave", :prompt => /Do/)
      @device.transport.command("yes", :noop => false)
    end
	addZoneToConfiguration
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Successfully added Member #{@resource[:member]} to Zone #{@resource[:zonename]}.")
  end

 def destroy
 end

def addZoneToConfiguration
   Puppet.debug("Puppet::Provider::brocade_manage_zone: Adding Zone to Config : #{@resource[:zonename]}, zonemember: #{@resource[:member]}, ConfigName: #{@resource[:configname]}.")
    response = String.new("")
    response =  @device.transport.command("cfgadd #{@resource[:configname]},#{@resource[:zonename]}", :noop => false)
   #Puppet.debug("response #{response}")

    if response.match("not found") 
      raise Puppet::Error, "Failed to Add Zone #{@resource[:zonename]} to the existing config #{@resource[:configname]}. Error: #{response}"
	else
      @device.transport.command("cfgsave", :prompt => /Do/)
    response = String.new("")
response =  @device.transport.command("yes", :noop => false)
if response.match(/fail|err|not found|not an alias/)
      raise Puppet::Error, "Failed to save config #{@resource[:configname]}. Error: #{response}"
    else
    Puppet.debug("Successfully saved config #{@resource[:configname]}")
end
	getEffectiveConfiguration
    end
end

def getEffectiveConfiguration
    response = String.new("")
    response =  @device.transport.command("zoneshow", :noop => false)
	match = /cfg:\s*(\S+)?/.match(response)
	Puppet.debug("got match" +$1+ "##############################")
	if match
        effectiveConfiguration = $1
		config = @resource[:configname]
		Puppet.debug("#{config} and #{effectiveConfiguration}")
      	if config == effectiveConfiguration
       		 enableZoneConfig
		end
	end
end

def enableZoneConfig 
    response = String.new("")
    @device.transport.command("cfgenable #{@resource[:configname]}",  :prompt => /Do/)
	response = @device.transport.command("yes", :noop => false)
	if response.match(/not found|not an alias|Invalid/)
      raise Puppet::Error, "Failed to enable config #{@resource[:configname]}. Error: #{response}"
    else
    Puppet.debug("Successfully enabled config #{@resource[:configname]}")
end

end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Checking existence of Brocade zone with zonename: #{@resource[:zonename]} #{@resource[:member]} .")
    self.transport
    response = String.new("")
    response = @device.transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if (response.match("does not exist."))
      raise Puppet::Error, "Failed to Add Member #{@resource[:member]} to the zone  #{@resource[:zonename]}. Error: #{response}"
    end
    if response.include? "#{@resource[:member]}"
	Puppet.debug("Puppet::Provider::brocade_manage_zone: member is already added")
	true
    else 
	Puppet.debug("Puppet::Provider::brocade_manage_zone: member is not added:")
    false
    end
	end

end

