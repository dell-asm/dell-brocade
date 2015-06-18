require 'puppet_x/brocade/value_helper'

#This class provides generic method to parse the fact from command output
class PuppetX::Brocade::Fact
  attr_accessor :name, :idx, :value, :evaluated
  extend PuppetX::Brocade::ValueHelper
  def initialize(name, transport, facts = nil, idx = 0, &block)
    @name = name
    @idx = idx
    @evaluated = false
    self.instance_eval(&block) 

  end

  define_value_method [:cmd, :match, :add, :remove, :before, :after, :match_param, :required]

  def parse(txt)
    if self.match.is_a?(Proc)
      self.value = self.match.call(txt)
    else
      self.value = txt.scan(self.match).flatten[self.idx]
    end
    self.evaluated = true
    if self.required == true && (self.value.nil? || self.value.to_s.empty?)
      raise Puppet::Error, "Fact: #{self.name} is required but didn't evaluate to a proper Value"
    end
  end
end
