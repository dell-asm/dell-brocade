require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

Puppet::Type.type(:brocade_alias).provide(:brocade_alias, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade alias creation and deletion."

  mk_resource_methods
  def initialize_resources
    @alias_name=@resource[:alias_name]
    @member_name=@resource[:member]
  end

  def create
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_CREATE_DEBUG%[@alias_name,@member_name])
    response = @transport.command((Puppet::Provider::Brocade_commands::ALIAS_CREATE_COMMAND%[@alias_name,@member_name]), :noop => false)
    if((response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG )|| (response.include? Puppet::Provider::Brocade_responses::RESPONSE_INVALID_NAME))
      raise Puppet::Error, Puppet::Provider::Brocade_messages::ALIAS_CREATE_ERROR%[@alias_name,response]
    elsif(response.include? Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME)
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_ALREADY_EXIST_INFO%[@alias_name])
    else
      cfg_save
    end
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_DESTROY_DEBUG%[@resource[:alias_name]])
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_DELETE_COMMAND%[@alias_name], :noop => false)
    if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      Puppet.info(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@alias_name])
    else
      cfg_save
    end
  end

  def exists?
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::ALIAS_EXIST_DEBUG%[@alias_name])
    self.device_transport
    response = @transport.command(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@alias_name], :noop => false)
    if !(response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
    true
    else
    false
    end
  end

end

