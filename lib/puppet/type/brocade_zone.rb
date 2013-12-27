require 'puppet/type/brocade_messages'

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
        raise ArgumentError, Puppet::Type::Brocade_messages::ZONE_NAME_BLANK_ERROR
      end
	  if ( value =~ /[\W]+/ )
        raise ArgumentError, Puppet::Type::Brocade_messages::ZONE_NAME_SPECIAL_CHAR_ERROR
      end
    end
  end

 newparam(:member) do
    desc "This parameter describes/displays the member to be added on the Brocade switch."
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, Puppet::Type::Brocade_messages::ALIAS_NAME_BLANK_ERROR
      end

      value.split(";").each do |line|
        item = line.strip
        if ( item =~ /[:]+/ )
          unless item  =~ /^([0-9a-f]{2}:){7}[0-9a-f]{2}$/
            raise ArgumentError, Puppet::Type::Brocade_messages::MEMBER_WWPN_INVALID_FORMAT_ERROR
          end
        elsif ( item =~ /[\W]+/ )
            raise ArgumentError, Puppet::Type::Brocade_messages::ALIAS_NAME_SPECIAL_CHAR_ERROR
        end
      end
    end
  end

end
