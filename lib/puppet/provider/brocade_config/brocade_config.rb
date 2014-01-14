require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/provider/brocade_commands'

def process_config_state(value)
  if value == :enable
    config_enable
  elsif value == :disable
    config_disable
  end
end

def process_config_creation
  Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_CREATE_DEBUG%[@config_name,resource[:member_zone]])
  response =  @transport.command(Puppet::Provider::Brocade_commands::CONFIG_CREATE_COMMAND%[@config_name, @member_zone], :noop => false)
  if !((response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase)||(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
    cfg_save
  else
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_CREATE_ERROR%[@config_name,response]
  end

  if "#{@config_state}" == "enable"
    config_enable
  end
end

def config_enable
  Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_ENABLE_DEBUG%[@config_name])
  @transport.command(Puppet::Provider::Brocade_commands::CONFIG_ENABLE_COMMAND%[@config_name], :prompt => Puppet::Provider::Brocade_messages::CONFIG_ENABLE_PROMPT)
  response = @transport.command(Puppet::Provider::Brocade_commands::YES_COMMAND, :noop => false)
  if response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_ENABLE_ERROR%[@config_name,response]
  end
end

def config_disable
  Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DISABLE_DEBUG)
  @transport.command(Puppet::Provider::Brocade_commands::CONFIG_DISABLE_COMMAND, :prompt => Puppet::Provider::Brocade_messages::CONFIG_DISABLE_PROMPT)
  @transport.command(Puppet::Provider::Brocade_commands::YES_COMMAND, :noop => false)
end

def destroy_config
  Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DESTORY_DEBUG%[@config_name])
  response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_DELETE_COMMAND%[@config_name], :noop => false)
  if (response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
    Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_ALREADY_REMOVED_INFO%[@config_name])
  elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_SHOULD_NOT_BE_DELETED || (response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
    raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_DESTROY_ERROR%[@config_name,response]
  else
    cfg_save
  end
end

Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage zone config creation, deletion and state change."

  mk_resource_methods
  def initialize_resources
    @config_name=@resource[:configname]
    @config_state=@resource[:configstate]
    @member_zone=@resource[:member_zone]
  end

  def create
    initialize_resources
    process_config_creation
  end

  def destroy
    initialize_resources
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DESTORY_DEBUG%[@config_name])
    destroy_config
  end

  def exists?
    initialize_resources
    self.device_transport
    response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_SHOW_COMMAND%[@config_name], :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST )
    false
    else
    true
    end
  end

  def configstate
    initialize_resources
    response = @transport.command(Puppet::Provider::Brocade_commands::CONFIG_ACTV_SHOW_COMMAND, :noop => false)
    if ( response.include? @config_name)
      :enable
    else
      :disable
    end
  end

  def configstate=(value)
    initialize_resources
    process_config_state(value)
  end
end
