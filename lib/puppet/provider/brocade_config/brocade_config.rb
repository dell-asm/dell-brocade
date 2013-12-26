require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and modification."
  mk_resource_methods

  def create
    self.transport
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)

    if ( response.include? "does not exist" )
      cfg_doesnt_exist
    else
      cfg_exists
    end
  end

  def cfg_doesnt_exist
    config_create
    if "#{@resource[:configstate]}" == "enable"
      config_enable  
    end  
  end

  def cfg_exists
    if "#{@resource[:configstate]}" == "enable"
      config_enable
    elsif "#{@resource[:configstate]}" == "disable"
      config_disable
    end
  end

  def destroy
    Puppet.debug("The Config #{@resource[:configname]} is being deleted.")
    response = @transport.command("cfgdelete  #{@resource[:configname]}", :noop => false)
    if (!response.include? "should not be deleted") && (!response.include? "not found")
      cfg_save
    else
      raise Puppet::Error, "#{response}" 
    end 
  end

  def config_create 
    Puppet.debug("A Config #{@resource[:configname]} with members #{@resource[:member_zone]} is being created.")
    response =  @transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    if (!response.include? "duplicate name" ) && (!response.include? "invalid name") && (!response.include? "invalid cfg")
      cfg_save
      Puppet.debug("Create Config : #{response}")
    else
      raise Puppet::Error, "#{response}"
    end
  end

  def config_enable
    Puppet.debug("The Config #{@resource[:configname]} is being enabled.")    
    @transport.command("cfgenable #{@resource[:configname]}", :prompt => /Do you want to enable/)
    response = @transport.command("yes", :noop => false)
    if response.include? "not found"
       raise Puppet::Error, "#{response}"
    end
    Puppet.debug("#{response}")
  end
  
  def config_disable
    response = @transport.command("cfgActvShow", :noop => false)
    if ( !response.include? "no configuration in effect" )	
      Puppet.debug("The current Config is being disabled.")    
      @transport.command("cfgDisable", :prompt => /Do you want to disable /)
      @transport.command("yes", :noop => false)
	else
	  Puppet.debug("Cannot disable config as no effective configuration found.")   
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
