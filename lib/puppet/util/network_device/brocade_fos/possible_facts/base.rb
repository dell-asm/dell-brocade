module Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base
  SWITCHSHOW_HASH = {
    'Switch Name' => 'switchName',
	  'Switch State' => 'switchState',
	  'Switch Domain' => 'switchDomain',
	  'Switch Wwn' => 'switchWwn',
	  'Zone Config' => 'zoning',
	  'Switch Beacon' => 'switchBeacon',
	  'Switch Role' => 'switchRole',
	  'Switch Mode' => 'switchMode',
	  'FC Router' => 'FC Router',
	  'FC Router BB Fabric ID' => 'FC Router BB Fabric ID'	
  }
  CHASISSSHOW_HASH = {
     'Switch Name' => 'Serial Num',
     'Switch State' => 'Factory Serial Num'    
   }
   
  HADUMP_HASH = {
       'Ethernet IP Address' => 'Ethernet IP Address',
       'Ethernet Subnetmask' => 'Ethernet Subnetmask',
       'Gateway IP Address' => 'Gateway IP Address'   
     }

  def self.register_brocade_param(base, command_val, hash_name)
  param_hash = hash_name
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
  
    #Register facts for switchshow command	  
    Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base.register_brocade_param(base,'switchshow',SWITCHSHOW_HASH) 

    #Register facts for chassisshow command	  
    Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base.register_brocade_param(base,'chassisshow',CHASISSSHOW_HASH)

    #Register facts for hadump command	  
    Puppet::Util::NetworkDevice::Brocade_fos::PossibleFacts::Base.register_brocade_param(base,'hadump',HADUMP_HASH)

    base.register_param ['FC Ports'] do
      match /FC ports =\s+(.*)?/
      cmd "switchshow -portcount"   
    end

    base.register_param ['Switch Health Status'] do
      match /SwitchState:\s+(.*)?/
      cmd "switchstatusshow"
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
