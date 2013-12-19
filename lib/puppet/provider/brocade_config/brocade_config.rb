require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and modification."
  mk_resource_methods

  def create
    response = String.new("")
    self.transport
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if ( response.include? "does not exist" ) && ( "#{@resource[:configstate]}" == "enable" )
      @resource.provider.configcreate
      @resource.provider.configenable
    end

    if ( response.include? "does not exist" ) && ("#{@resource[:configstate]}" == "disable")
      @resource.provider.configcreate
    end

    if (!response.include? "does not exist" ) && ( "#{@resource[:configstate]}" == "enable" )  
      @resource.provider.configenable
    end

    if (!response.include? "does not exist" ) && ( "#{@resource[:configstate]}" == "disable")
      @resource.provider.configdisable
    end
  end

  def destroy
    response = String.new("")
    Puppet.debug("Deleting Config #{@resource[:configname]}")
    response = @transport.command("cfgdelete  #{@resource[:configname]}", :noop => false)
    if !response.include? "should not be deleted."
      Puppet.debug(response)
      if !response.include? "not found"
        @transport.command("cfgsave", :prompt => /Do/)
        @transport.command("yes", :noop => false)
      end
    else 
      Puppet.debug(response)
    end 
  end

  def configcreate 
    response = String.new("")
    Puppet.debug("Creating Config #{@resource[:configname]} with members #{@resource[:member_zone]}")
    response =  @transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    #Puppet.debug("Puppet::Provider::zone_config: response #{response}. \n")
    if !response.include? "duplicate name" 
      @transport.command("cfgsave", :prompt => /Do/)
      @transport.command("yes", :noop => false)
    end
  end

  def configenable
    response = String.new("")
    Puppet.debug("Enabling Config #{@resource[:configname]}.")    
    @transport.command("cfgenable #{@resource[:configname]}", :prompt => /Do you want to enable/)
    response = @transport.command("yes", :noop => false)
    if !response.include? "not found"
      puts "Config: #{@resource[:configname]} does not exist."
    end
  end
  
  def configdisable
    response = String.new("")
    Puppet.debug("Disabling Config #{@resource[:configname]}.")    
    @transport.command("cfgDisable", :prompt => /Do you want to disable /)
    @transport.command("yes", :noop => false)
  end

  def exists?
    self.device_transport
    response = String.new("")
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if "#{@resource[:ensure]}" == "present" 
      false
    else
      true
    end
  end

end
