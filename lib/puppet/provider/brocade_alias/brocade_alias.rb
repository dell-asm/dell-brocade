require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

Puppet::Type.type(:brocade_alias).provide(:brocade_alias, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade alias creation and deletion."

 mk_resource_methods


 def create
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_CREATE_DEBUG%[@resource[:alias_name],@resource[:member]])
    response = @transport.command("alicreate #{@resource[:alias_name]}, \"#{@resource[:member]}\"", :noop => false)
    if !(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG || response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID_NAME)
     cfg_save
	elsif !response.include? Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME
	 Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_ALREADY_EXIST_INFO%[@resource[:alias_name]])
	else
	 raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_CREATE_ERROR %[@resource[:alias_name],response]
    end
  end

  def destroy
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_DESTROY_DEBUG%[@resource[:alias_name]])
    response = @transport.command("alidelete  #{@resource[:alias_name]}", :noop => false)
    if !response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND
       cfg_save
    end
  end

  def exists?
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_EXIST_DEBUG%[@resource[:alias_name]])
    self.device_transport
    response = @transport.command("alishow #{@resource[:alias_name]}", :noop => false)
    if !response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST
      true
    else
      false
    end
  end

end

