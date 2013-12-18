require 'puppet/provider/brocade_fos'

Puppet::Type.type(:brocade_member_alias).provide(:brocade_member_alias, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade member alias creation, modification and deletion."

 mk_resource_methods


 def create
    Puppet.debug("Puppet::Provider::brocade_member_alias: Creating Brocade alias: #{@resource[:alias_name]}, for member:  #{@resource[:member]}.")
    response = @transport.command("alicreate #{@resource[:alias_name]}, #{@resource[:member]}", :noop => false)
    if !response.include? "duplicate name"
      @transport.command("cfgsave", :prompt => /Do/)
      @transport.command("yes", :noop => false)
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_member_alias: Destroying Brocade alias: #{@resource[:alias_name]}.")
    response = @transport.command("alidelete  #{@resource[:alias_name]}", :noop => false)
    if !response.include? "not found"
       @transport.command("cfgsave", :prompt => /Do/)
       @transport.command("yes", :noop => false)
    end
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_member_alias: Checking existence of alias: #{@resource[:alias_name]}.")
    self.device_transport
    response = @transport.command("alishow #{@resource[:alias_name]}", :noop => false)
    if !response.include? "does not exist."
      true
    else
      false
    end
  end

end

