require 'puppet/util/network_device/brocade_fos/possible_facts'

module Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base
  def self.register(base)
    
   base.register_param ['Switch Name'] do
      match /switchName:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['Switch State'] do
      match /switchState:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['Switch Domain'] do
      match /switchDomain:\s+(.*)?/
      cmd "switchshow"
   end
   
   base.register_param ['Switch Wwn'] do
      match /switchWwn:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['Zone Config'] do
      match /zoning:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['Switch Beacon'] do
      match /switchBeacon:\s+(.*)?/
      cmd "switchshow"
   end
   
   base.register_param ['Switch Role'] do
      match /switchRole:\s+(.*)?/
      cmd "switchshow"
   end
   
   base.register_param ['Switch Mode'] do
      match /switchMode:\s+(.*)?/
      cmd "switchshow"
   end
   
   base.register_param ['FC Router'] do
      match /FC Router:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['FC Router BB Fabric ID'] do
      match /FC Router BB Fabric ID:\s+(.*)?/
      cmd "switchshow"
   end

   base.register_param ['FC Ports'] do
      match /FC ports =\s+(.*)?/
      cmd "switchshow -portcount"
   end

   base.register_param ['Switch Health Status'] do
      match /SwitchState:\s+(.*)?/
      cmd "switchstatusshow"
   end

   base.register_param ['Serial Number'] do
      match /Serial Num:\s+(.*)?/
      cmd "chassisshow"
   end

   base.register_param ['Factory Serial Number'] do
      match /Factory Serial Num:\s+(.*)?/
      cmd "chassisshow"
   end

   base.register_param ['Ethernet IP Address'] do
      match /Ethernet IP Address:\s+(.*)?/
      cmd "hadump"
   end

   base.register_param ['Ethernet Subnetmask'] do
      match /Ethernet Subnetmask:\s+(.*)?/
      cmd "hadump"
   end

   base.register_param ['Gateway IP Address'] do
      match /Gateway IP Address:\s+(.*)?/
      cmd "hadump"
   end

   base.register_param ['Fabric Os'] do
      match /OS:\s+(.*)?/
      cmd "version"
   end

  end
end
