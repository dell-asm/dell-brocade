module Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base
  SWITCHSHOW_HASH = {
    'Switch Name' => 'switchName'
  }

def self.register_brocade_param(base, command_val)
  param_hash = Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base::SWITCHSHOW_HASH
  param_hash.keys.each do |key|
    base.register_param key do
      s = param_hash[key]+ ":" + "\\s+(.*)?"
      reg = Regexp.new(s)
      match reg
      cmd command_val
    end
  end
end

  def self.register(base)

 Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base.register_brocade_param(base,'switchshow')

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

   base.register_param 'Zone_Config' do
      match do |txt|
        res = Hash.new
        i=0
        txt.split("\n").map do |line|
          item=line.scan(/cfg:\s+(.*)\b\s/)
            item = item.flatten.first
            if item.nil? || item.empty? || item =~ /^\s+$/ || res.has_value?(item) then
              next
            else
              i=i+1
              res["Zone_Config_#{i}"]=item
            end
        end
        res
      end
      cmd "zoneshow"
   end

   base.register_param ['Configs'] do
      configList = ""
      match do |txt|
        txt.split("\n").each do |line|
          item=line.scan(/cfg:\s+(.*)\b\s/)
            item = item.flatten.first
            if item.nil? || item.empty? || item =~ /^\s+$/ || ( configList.include? item ) then
              next
            else
              if configList.nil? || configList.empty? then
                configList = configList + "#{item}"
              else
               configList = configList + ", #{item}"
             end
          end
        end
        configList
      end
      cmd "zoneshow"
   end

   base.register_param ['Zones'] do
      zonesList = ""
      match do |txt|
        txt.split("\n").each do |line|
          item=line.scan(/zone:\s+(.*)\b\s/)
            item = item.flatten.first
            if item.nil? || item.empty? || item =~ /^\s+$/ then
              next
            else
              if zonesList.nil? || zonesList.empty? then
                zonesList = zonesList + "#{item}"
              else
               zonesList = zonesList + ",  #{item}"
             end
          end
        end
        zonesList
      end
      cmd "zoneshow"
   end

   base.register_param ['Alias'] do
      aliList = ""
      match do |txt|
        txt.split("\n").each do |line|
          item=line.scan(/alias:\s+(.*)\b\s/)
            item = item.flatten.first
            if item.nil? || item.empty? || item =~ /^\s+$/ then
              next
            else
              if aliList.nil? || aliList.empty? then
                aliList = aliList + "#{item}"
              else
               aliList = aliList + ", #{item}"
             end
          end
        end
        aliList
      end
      cmd "zoneshow"
   end


  end
end
