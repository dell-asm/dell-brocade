require 'puppet/provider/brocade_fos'
require 'puppet/provider'

Puppet::Type.type(:brocade_manage_zone).provide(:brocade_manage_zone, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone member addition and removal from/to zone."

  mk_resource_methods
  def create
    Puppet.debug("Puppet::Provider::brocade_manage_zone: A zone member with the zonename: #{@resource[:zonename]}, zonemember: #{@resource[:member]} and ConfigName: #{@resource[:configname]} is being added to the zone.")
    response = String.new("")
    response = @transport.command("zoneadd #{@resource[:zonename]},#{@resource[:member]}", :noop => false)
    if response.include? "duplicate name"
      saveconfiguration
    end
    add_zone_to_configuration
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Successfully added a member #{@resource[:member]} to the zone #{@resource[:zonename]}.")
  end

  def saveconfiguration
    @transport.command("cfgsave", :prompt => /Do/)
    response = String.new("")
    response =  @transport.command("yes", :noop => false)
    if response.match(/fail|err|not found|not an alias/)
      raise Puppet::Error, "Unable to save the config #{@resource[:configname]} because of the following issue: #{response}"
    else
      Puppet.debug("Successfully saved the config #{@resource[:configname]}")
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Removing Member from zone with zonename: #{@resource[:zonename]}, zonemember: #{@resource[:member]}, ConfigName: #{@resource[:configname]}.
")
    response = String.new("")
    response =  @transport.command("zoneremove #{@resource[:zonename]},#{@resource[:member]}", :noop => false)
    saveconfiguration
	remove_zone_from_configuration
  end

  def remove_zone_from_configuration
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Removing Zone from Config : #{@resource[:zonename]}, zonemember: #{@resource[:member]}, ConfigName: #{@resource[:configname]}.")
    response = String.new("")
    response =  @transport.command("cfgremove #{@resource[:configname]},#{@resource[:zonename]}", :noop => false)
    saveconfiguration
    get_effective_configuration

  end

  def add_zone_to_configuration 
    Puppet.debug("Puppet::Provider::brocade_manage_zone: A zone is being added to the Config : #{@resource[:zonename]}, zonemember: #{@resource[:member]}, ConfigName: #{@resource[:configname]}.")
    response = String.new("")
    response =  @transport.command("cfgadd #{@resource[:configname]},#{@resource[:zonename]}", :noop => false)
    #Puppet.debug("response #{response}")

    if response.match("not found")
      raise Puppet::Error, "Unable to add Zone #{@resource[:zonename]} to the existing config #{@resource[:configname]} because of the following issue: #{response}"
    else
      saveconfiguration
      get_effective_configuration
    end
  end

  def get_effective_configuration
    response = String.new("")
    response =  @transport.command("zoneshow", :noop => false)
    match = /cfg:\s*(\S+)?/.match(response)
    Puppet.debug("got match" +$1+ "##############################")
    if match
      effectiveConfiguration = $1
      config = @resource[:configname]
      Puppet.debug("#{config} and #{effectiveConfiguration}")
      if config == effectiveConfiguration
        enable_zone_config
      end
    end
  end

  def enable_zone_config
    response = String.new("")
    @transport.command("cfgenable #{@resource[:configname]}",  :prompt => /Do/)
    response = @transport.command("yes", :noop => false)
    if response.match(/not found|not an alias|Invalid/)
      raise Puppet::Error, "Failed to enable config #{@resource[:configname]}. Error: #{response}"
    else
      Puppet.debug("Successfully enabled the config #{@resource[:configname]}")
    end

  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_manage_zone: Verifying whether or not the Brocade zone with zonename: #{@resource[:zonename]} #{@resource[:member]} exists.")
    self.device_transport
    response = String.new("")
    response = @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if (response.match("does not exist."))
      raise Puppet::Error, "Unable to add a member #{@resource[:member]} to the zone  #{@resource[:zonename]} because of the following issue: #{response}"
    end
    if response.include? @resource[:member]
      Puppet.debug("Puppet::Provider::brocade_manage_zone: member is already added")
    true
    else
      Puppet.debug("Puppet::Provider::brocade_manage_zone: member is not added:")
    false
    end
  end

end
