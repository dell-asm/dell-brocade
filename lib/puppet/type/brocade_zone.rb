Puppet::Type.newtype(:brocade_zone) do
  @doc = "This represents a zone on a brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "This parameter describes the zone name to be created on the Brocade switch."
    isnamevar
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Unable to perform the operation because the zone name is invalid."
      end
	  if ( value =~ /[\W]+/ )
        raise ArgumentError, "Brocade does not support special characters in zone name."
      end
    end
  end

 newparam(:member) do
    desc "This parameter describes/displays the member to be added on the Brocade switch."
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Unable to perform the operation because the member name is invalid."
      end

      value.split(";").each do |line|
        item = line.strip
        if ( item =~ /[:]+/ )
          unless item  =~ /^([0-9a-f]{2}:){7}[0-9a-f]{2}$/
            raise ArgumentError, "The MemberWWPN value is invalid. A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format."
          end
        elsif ( item =~ /[\W]+/ )
            raise ArgumentError, "Brocade does not support special characters in member alias."
        end
      end
    end
  end

end
