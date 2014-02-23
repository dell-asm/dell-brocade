require 'json'

# Base class for all possible facts
module Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Custom
  def self.register(base)

    fcport = base.facts['FC Ports'].value
    if fcport.nil? || fcport.empty? then
      # if not available default to 0
      fcport="0"
    end
    portcount=Integer(fcport)-1

    base.register_param ['RemoteDeviceInfo '] do
      rdevice = Hash.new
      ports=nil
      match do |txt|
        txt.split(/portIndex:\s+(.*)/).each do |text|
          location=text.scan(/portName:\s+(.*)/).flatten.first
          if !(location.nil? || location.empty?)
            ports=Hash.new
            macadd=text.scan(/portWwn of device\(s\) connected:\s(.*)Distance/m).flatten.first.strip
            ports[:location] = location
            ports[:mac_address] = macadd
            rdevice[ports[:location]]  = ports
          end
        end
        rdevice.to_json
      end
      cmd "portshow -i 0-#{portcount}"
      # after 'FC Ports'
    end
    
    
    
  end
end
