require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and modification."
  mk_resource_methods

  def create
    self.transport
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if ( response.include? "does not exist" )
      cfg_doesnt_exist
    #end
    #if (!response.include? "does not exist" )
    else
      cfg_exists
    end
  end

  def cfg_doesnt_exist
    if "#{@resource[:configstate]}" == "enable"
      config_create
      config_enable  
    else
      config_create
    end  
  end

  def cfg_exists
    if "#{@resource[:configstate]}" == "enable"
      config_enable
    else
      config_disable
    end
  end

  def destroy
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

  def config_create 
    Puppet.debug("Creating Config #{@resource[:configname]} with members #{@resource[:member_zone]}")
    response =  @transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    if !response.include? "duplicate name" 
      @transport.command("cfgsave", :prompt => /Do/)
      @transport.command("yes", :noop => false)
    else 
      Puppet.debug("Create Config : #{response}")
    end
  end

  def config_enable
    Puppet.debug("Enabling Config #{@resource[:configname]}.")    
    @transport.command("cfgenable #{@resource[:configname]}", :prompt => /Do you want to enable/)
    response = @transport.command("yes", :noop => false)
    if !response.include? "not found"
      Puppet.debug("Config: #{@resource[:configname]} does not exist.")
    end
  end
  
  def config_disable
    Puppet.debug("Disabling Config #{@resource[:configname]}.")    
    @transport.command("cfgDisable", :prompt => /Do you want to disable /)
    @transport.command("yes", :noop => false)
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
