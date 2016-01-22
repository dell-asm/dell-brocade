require 'puppet_x/brocade/model_values'
require 'json'

# Base class for all possible facts
module PuppetX::Brocade::PossibleFacts
  module Base
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
      'Serial Number' => 'Serial Num',
      'Factory Serial Number' => 'Factory Serial Num'
    }

    IPADDRESSSHOW_HASH = {
      'Ethernet IP Address' => 'Ethernet IP Address',
      'Ethernet Subnetmask' => 'Ethernet Subnetmask',
      'Gateway IP Address' => 'Gateway IP Address'
    }

    DEFAULTVALUE_HASH = {
      'Manufacturer' => 'Brocade',
      'Protocols Enabled' => 'FC',
      'Boot Image' => 'Not Available',
      'Processor' => 'Not Available',
      'Port Channels' => 'Not Available',
      'Port Channel Status' => 'Not Available'

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
    def self.register_param_with_defaultvalues(base, command_val, hash_name)
      param_hash = hash_name
      param_hash.keys.each do |key|
        base.register_param key do
          val = param_hash[key]
          match do |txt|
            val
          end
          cmd command_val
        end
      end
    end

    def self.register(base)

      #Register facts for switchshow command
      PuppetX::Brocade::PossibleFacts::Base.register_brocade_param(base,'switchshow',SWITCHSHOW_HASH)

      #Register facts for chassisshow command
      PuppetX::Brocade::PossibleFacts::Base.register_brocade_param(base,'chassisshow',CHASISSSHOW_HASH)

      #Register facts for hadump command
      PuppetX::Brocade::PossibleFacts::Base.register_brocade_param(base,'ipaddrshow',IPADDRESSSHOW_HASH)

      PuppetX::Brocade::PossibleFacts::Base.register_param_with_defaultvalues(base,'switchshow',DEFAULTVALUE_HASH)

      base.register_param ['FC Ports'] do
        match /FC ports =\s+(.*)?/
        cmd "switchshow -portcount"
      end
      base.register_param ['Model'] do
        match do |txt|
          switchtype=txt.scan(/switchType:\s+(.*)?/).flatten.first
          model=PuppetX::Brocade::ModelValues::MODEL_MAP[switchtype]

          if model.nil? || model.empty?
            switchtype = switchtype.partition('.').first + '.x'
            model=PuppetX::Brocade::ModelValues::MODEL_MAP[switchtype]
          end
        model
        end
        cmd "switchshow"
      end

      base.register_param ['Switch Health Status'] do
        match /SwitchState:\s+(.*)?/
        cmd "switchstatusshow"
      end

      base.register_param ['Fabric Os'] do
        match /OS:\s+(.*)?/
        cmd "version"
      end

      base.register_param ['Memory(bytes)'] do
        match /Mem:\s+(\d*)/
        cmd "memshow"
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

      base.register_param ['Aliases_Members'] do

        match do |txt|
          alias_members = {}
          aliases = base.facts['Alias'].value
          switch_name = base.facts['Switch Name'].value
          Puppet.debug("Alias values identified: #{aliases}")
          aliases.split(',').each do |alias_val|
            alias_val.strip!
            alias_members[alias_val] = []
            output = base.transport.command("alishow #{alias_val}")
            output.split("\n").each do |line|
              next if line.match(/alishow|alias:|#{switch_name}:/)
              item=line.scan(/\S+/).flatten
              if item.nil? || item.empty? || item =~ /^\s+$/ then
                next
              else
                item.collect {|i| alias_members[alias_val].push(i.gsub(/;/,'')) }
              end
            end
          end
          alias_members.to_json
        end

        cmd "zoneshow"
      end

      base.register_param ['Zone_Members'] do
        match do |txt|
          zone_members = {}
          zones = base.facts['Zones'].value
          alias_members = base.facts['Aliases_Members'].value || {}
          unless alias_members.empty?
            alias_members = JSON.parse(alias_members)
          end
          switch_name = base.facts['Switch Name'].value
          zones.split(',').each do |zone_val|
            zone_val.strip!
            zone_members[zone_val] = []
            output = base.transport.command("zoneshow \"#{zone_val}\"")
            output.split("\n").each do |line|
              next if line.match(/zoneshow|zone:|#{switch_name}:/)
              item=(line.scan(/\S+/).flatten || []).first
              if item.nil? || item.empty? || item =~ /^\s+$/ then
                next
              else
                item.split(';').each do  |i|
                  i.strip!
                  if alias_members[i].nil?
                    zone_members[zone_val].push(i)
                  else
                    zone_members[zone_val].push(*alias_members[i])
                  end
                end
              end
            end
          end
          zone_members.to_json
        end

        cmd "zoneshow"
      end

      base.register_param ['Nameserver'] do
        nameserver_info=Hash.new()
        match do |txt|
          alias_members = JSON.parse(base.facts['Aliases_Members'].value)
          Puppet.debug("Alias Members: #{alias_members}")
          match_array=txt.scan(/N\s+(\w+);(.*)\s+\w+:.*\s+(.*)\s+.*\s+.*\s+Permanent Port Name:\s+(\S+)\s+Device type:\s+(.*)\s+.*\s+.*\s+.*\s+.*\s+.*\s+.*\s+Aliases:(.*)/)
          Puppet.debug"match_array: #{match_array.inspect}"
          if !match_array.empty?
            match_array.each do |nameserverinfo|
              Puppet.debug"Nameserver: #{nameserverinfo}"
              nsinfo=Hash.new
              nsinfo[:nsid] = nameserverinfo[0]
              wwpninfo=nameserverinfo[1]
              temp_match=wwpninfo.scan(/\d+;(\S+);(\S+);\s+na/)
              nsinfo[:remote_wwpn] = temp_match[0][0]
              nsinfo[:local_wwpn] = temp_match[0][1]
              nsinfo[:port_info] = nameserverinfo[2]
              nsinfo[:permanent_port] = nameserverinfo[3]
              nsinfo[:device_type] = nameserverinfo[4]
              # Check if there are more than one alias name
              device_aliases = (nameserverinfo[5] || '').strip.scan(/\S+/).flatten
              if device_aliases.size > 1
                device_aliases.each do |device_alias|
                  if alias_members[device_alias].nil?
                    nsinfo[:device_alias] = nameserverinfo[5]
                    break
                  elsif alias_members[device_alias].size > 1
                    nsinfo[:device_alias] = device_alias.strip
                  end
                end
              else
                nsinfo[:device_alias] = nameserverinfo[5]
              end
              #nameinfo[:device_alias] = '' if nameserverinfo[5].nil? or nameserverinfo[5].empty?
              #nsinfo[:device_alias] = nameserverinfo[5]
              nameserver_info[nsinfo[:nsid]] = nsinfo
            end
          end
          Puppet.debug("Name server info: #{nameserver_info.to_json}")
          nameserver_info.to_json
        end
        cmd "nsaliasshow -t"
      end

      base.register_param ['Effective Cfg'] do
        effective_cfg = ""
        match do |txt|
          match_array=txt.scan(/Effective configuration:\s+cfg:\s*(\S+)/)
          if !match_array.empty?
            effective_cfg=match_array[0][0]
          end
          effective_cfg
        end
        cmd "cfgshow"
      end



      base.register_module_after 'FC Ports', 'custom' do
        base.facts['FC Ports'].value != nil
      end
    end
  end
end
