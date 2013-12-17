require 'puppet/provider/brocade_fos'

Puppet::Type.type(:zone_config).provide(:zone_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and modification."
  mk_resource_methods

  def create
    Puppet.debug("Puppet::Provider::zone_config: creating zone config for #{@resource[:configname]} member_zone  #{@resource[:member_zone]}. \n")
    self.transport
	
    response = String.new("")
    Puppet.debug("Creating  Config #{@resource[:configname]} #{@resource[:member_zone]}")
    response =  @device.transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    Puppet.debug("Puppet::Provider::zone_config: response #{response}. \n")
    if !response.include? "duplicate name" 
      @device.transport.command("cfgsave", :prompt => /Do/)
      @device.transport.command("yes", :noop => false)
    end
  end

  def destroy
    self.transport
    response = String.new("")
    response = @device.transport.command("cfgdelete  #{@resource[:configname]}", :noop => false)
    Puppet.debug(response)
    if !response.include? "not found"
       @device.transport.command("cfgsave", :prompt => /Do/)
       @device.transport.command("yes", :noop => false)
    end
  end

  def exists?
    #Puppet.debug("exists method configuration state-----#{@resource[:state]}")
    self.transport
    response = String.new("")
    response = @device.transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if !response.include? "does not exist."
      true
    else
      false
    end
  end


end
