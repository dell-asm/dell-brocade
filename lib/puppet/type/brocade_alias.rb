Puppet::Type.newtype(:brocade_alias) do
  @doc = "This represents an alias name for a member on a brocade switch."

  apply_to_device

  ensurable

  newparam(:alias_name) do
    desc "This parameter describes the Brocade alias name for the MemberWWPN."
    isnamevar
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Unable to perform the operation because the Brocade alias name is invalid."
      end
	  if ( value =~ /[\W]+/ )
        raise ArgumentError, "Brocade does not support special characters in alias name."
      end
    end
  end

  newparam(:member) do
    desc "This parameter describes the MemberWWPN value whose alias is to be added."
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError , "Enter a correct MemberWWPN value. A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format." 
       end 
       value.split(";").each do |line|
        item = line.strip
        unless item  =~ /^([0-9a-f]{2}:){7}[0-9a-f]{2}$/
          raise ArgumentError, "The MemberWWPN value is invalid. A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format." 
        end    
      end
	 end
  end

end
