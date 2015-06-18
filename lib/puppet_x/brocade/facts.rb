require 'puppet_x/brocade/fact'
require 'puppet_x/brocade/possible_facts'
require 'puppet_x/brocade/sorter'
require 'puppet_x/brocade/dsl'

#Lookup class which helps in registering the facts and retrieving the fact values
class PuppetX::Brocade::Facts

  include PuppetX::Brocade::Dsl

  attr_reader :transport
  def initialize(transport)
    @transport = transport
  end

  def mod_path_base
    return 'puppet_x/brocade/possible_facts'
  end

  def mod_const_base
    return PuppetX::Brocade::PossibleFacts
  end

  def param_class
    return PuppetX::Brocade::Fact
  end

  def facts
    @params
  end

  def facts_to_hash
    params_to_hash
  end
end
