require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'

Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and state change."
  mk_resource_methods

  def create    
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST )
      process_config_creation
	else
      Puppet.info("Config #{@resource[:configname]} already exists.")
    end	
    process_config_state
  end

  def process_config_state
    if "#{@resource[:configstate]}" == "enable"
      config_enable
    elsif "#{@resource[:configstate]}" == "disable"
      config_disable
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_config: The Config #{@resource[:configname]} is being deleted.")
    response = @transport.command("cfgdelete  #{@resource[:configname]}", :noop => false)
    if (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_SHOULD_NOT_BE_DELETED ) && (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND )
      cfg_save
    else
      raise Puppet::Error, "Could not delete the config #{@resource[:configname]} because of the following issue: #{response}" 
    end 
  end

  def process_config_creation 
    Puppet.debug("Puppet::Provider::brocade_config: A Config #{@resource[:configname]} with members #{@resource[:member_zone]} is being created.")
    response =  @transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    if (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME ) && (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID) 
      cfg_save
    else
      raise Puppet::Error, "Could not create the config #{@resource[:configname]} because of the following issue: #{response}"
    end
  end

  def config_enable
    Puppet.debug("Puppet::Provider::brocade_config: The Config #{@resource[:configname]} is being enabled.")    
    @transport.command("cfgenable #{@resource[:configname]}", :prompt => /Do you want to enable/)
    response = @transport.command("yes", :noop => false)
    if response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND
       raise Puppet::Error, "Could not enable the config #{@resource[:configname]} because of the following issue: #{response}"
    end
  end
 
  def config_disable
    response = @transport.command("cfgActvShow", :noop => false)
    if ( !response.include? "no configuration in effect" )	
      Puppet.debug("Puppet::Provider::brocade_config: The current effective Config is being disabled.")    
      @transport.command("cfgDisable", :prompt => /Do you want to disable /)
      @transport.command("yes", :noop => false)
	else
	  Puppet.info("Could not disable the config as no effective configuration found.")   
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
