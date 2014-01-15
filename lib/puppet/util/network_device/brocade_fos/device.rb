require 'puppet'
require 'puppet/util'
require 'puppet/util/network_device/base_fos'
require 'puppet/util/network_device/brocade_fos/facts'

#This class is called by the puppet framework for retrieving the facts. It retrieves the facts and initialize the switch variables.
class Puppet::Util::NetworkDevice::Brocade_fos::Device < Puppet::Util::NetworkDevice::Base_fos

  attr_accessor :enable_password, :switch
  def initialize(url, options = {})
    super(url)
    @initialized = false
    transport.default_prompt = /[#>]\s?\z/n
  end

  def connect_transport
    transport.connect
    login
  end

  def login
    return if transport.handles_login?
    if @url.user != ''
      transport.command(@url.user, {:prompt => /^Password:/, :noop => false})
    else
      transport.expect(/^Password:/)
    end
    transport.command(@url.password, :noop => false)
  end

  def init
    unless @initialized
      connect_transport
      init_facts
      @initialized = true
    end
    return self
  end

  def init_facts
    @facts ||= Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(transport)
    @facts.retrieve
  end

  def facts
    # This is here till we can fork Puppet
    init
    @facts.facts_to_hash
  end
  
  def get_facts
    return @facts
  end
  
  def set_facts(in_facts)
    @facts = in_facts
  end

end

