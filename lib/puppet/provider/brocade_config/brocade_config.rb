require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

  def create_config
    response = @transport.command("cfgshow #{@resource[:configname]}", :noop => false)
    if ( response.include? Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST )
      process_config_creation
    else
      Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_ALREADY_EXIST%[@resource[:configname]])
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

  def process_config_creation 
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_CREATE_DEBUG%[@resource[:configname],resource[:member_zone]])
    response =  @transport.command("cfgcreate  #{@resource[:configname]},  \"#{@resource[:member_zone]}\"", :noop => false)
    if !((response.downcase.include? (Puppet::Provider::Brocade_responses::RESPONSE_INVALID).downcase)||(response.include? Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG ))
      cfg_save
    else
      raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_CREATE_ERROR%[@resource[:configname],response]
    end
  end

  def config_enable
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_ENABLE_DEBUG%[@resource[:configname]])    
    @transport.command("cfgenable #{@resource[:configname]}", :prompt => Puppet::Provider::Brocade_messages::CONFIG_ENABLE_PROMPT)
    response = @transport.command("yes", :noop => false)
    if response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND
       raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_ENABLE_ERROR%[@resource[:configname],response]
    end
  end
 
  def config_disable
    response = @transport.command("cfgActvShow", :noop => false)
    if ( !response.include? Puppet::Provider::Brocade_responses::RESPONSE_NO_EFFECTIVE_CONFIG )
      Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DISABLE_DEBUG)
      @transport.command("cfgDisable", :prompt => Puppet::Provider::Brocade_messages::CONFIG_DISABLE_PROMPT)
      @transport.command("yes", :noop => false)
    else
      Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_NO_EFFECTIVE_CONFIG)
    end
  end

  def destroy_config
    Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DESTORY_DEBUG%[@resource[:configname]])
    response = @transport.command("cfgdelete  #{@resource[:configname]}", :noop => false)
    if (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_SHOULD_NOT_BE_DELETED ) && (!response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND )
      cfg_save
    elsif (response.include? Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
	  Puppet.info(Puppet::Provider::Brocade_messages::CONFIG_ALREADY_REMOVED_INFO%[@resource[:configname]])
	else
      raise Puppet::Error, Puppet::Provider::Brocade_messages::CONFIG_DESTROY_ERROR%[@resource[:configname],response]
    end
  end


  Puppet::Type.type(:brocade_config).provide(:brocade_config, :parent => Puppet::Provider::Brocade_fos) do
    @doc = "Manage zone config creation, deletion and state change."
    mk_resource_methods

    def create    
      create_config
    end

    def destroy
      Puppet.debug(Puppet::Provider::Brocade_messages::CONFIG_DESTORY_DEBUG%[@resource[:configname]])
      destroy_config
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
