require 'puppet/util/network_device/brocade_fos'
require 'puppet/util/network_device/brocade_fos/fact'
require 'puppet/util/network_device/brocade_fos/possible_facts'
require 'puppet/util/network_device/sorter'
require 'puppet/util/network_device/dsl'

#Lookup class which helps in registering the facts and retrieving the fact values
class Puppet::Util::NetworkDevice::Brocade_fos::Facts

  include Puppet::Util::NetworkDevice::Dsl

  attr_reader :transport
  def initialize(transport)
    @transport = transport
  end

  def mod_path_base
    return 'puppet/util/network_device/brocade_fos/possible_facts'
  end

  def mod_const_base
    return Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts
  end

  def param_class
    return Puppet::Util::NetworkDevice::Brocade_fos::Fact
  end

  # TODO
  def facts
    @params
  end

  def facts_to_hash
    params_to_hash
  end
end
