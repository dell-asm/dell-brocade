Puppet::Type.newtype(:brocade_member_alias) do
  @doc = "This represents an alias name for a member on a brocade switch."

  apply_to_device

  ensurable

  newparam(:alias_name) do
    desc "memeber added in the zone"
    isnamevar
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid zone name."
      end
    end
  end

  newparam(:member) do
    desc "Zone name"
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError , "member name cannot be empty." 
       end 
       
       unless value  =~ /([0-9a-f]{2}:){7}[0-9a-f]{2}/
         raise ArgumentError, " member WWPN supported format XX:XX:XX:XX:XX:XX:XX:XX." 
        end    
      end
  end

end
