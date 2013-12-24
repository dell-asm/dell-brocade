require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_alias).provide(:brocade_alias, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade alias creation and deletion."

 mk_resource_methods


 def create
    Puppet.debug("Puppet::Provider::brocade_alias: A Brocade alias: #{@resource[:alias_name]}, for member: #{@resource[:member]} is being created.")
    response = @transport.command("alicreate #{@resource[:alias_name]}, \"#{@resource[:member]}\"", :noop => false)
    if !response.include? "duplicate name"
      cfg_save
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_alias: A Brocade alias: #{@resource[:alias_name]} is being destroyed.")
    response = @transport.command("alidelete  #{@resource[:alias_name]}", :noop => false)
    if !response.include? "not found"
       cfg_save
    end
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_alias: Verifying whether or not the Brocade alias: #{@resource[:alias_name]} exists.")
    self.device_transport
    response = @transport.command("alishow #{@resource[:alias_name]}", :noop => false)
    if !response.include? "does not exist."
      true
    else
      false
    end
  end

end

