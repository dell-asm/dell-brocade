Puppet::Type.newtype(:brocade_member_alias) do
  @doc = "This represents an alias name for a member on a brocade switch."

  apply_to_device

  ensurable

  newparam(:alias_name) do
    desc "Alias name for the MemberWWPN"
    isnamevar
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid alias name."
      end
    end
  end

  newparam(:member) do
    desc "MemberWWPN, whose alias is to be added"
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError , "MemberWWPN value cannot be empty." 
       end 
       
       unless value  =~ /([0-9a-f]{2}:){7}[0-9a-f]{2}/
         raise ArgumentError, " Invalid memberWWPN value, supported format is XX:XX:XX:XX:XX:XX:XX:XX." 
        end    
      end
  end

end
