require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_config_membership) do
  @doc = "This represents a zone config membership on a brocade switch."

  apply_to_device

  ensurable do
    desc "config zone addition, removal ensure property."
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:configname) do
    desc "Config name"
    isnamevar
    newvalues(/[\w]+/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, Puppet::Type::Brocade_messages::CONFIG_NAME_BLANK_ERROR
      end
      if ( value =~ /[\W]+/ )
        raise ArgumentError, Puppet::Type::Brocade_messages::CONFIG_NAME_SPECIAL_CHAR_ERROR
      end
    end
  end

  newparam(:member_zone) do
    desc "zone added in the config"
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, Puppet::Type::Brocade_messages::ZONE_NAME_BLANK_ERROR
      end
      value.split(";").each do |line|
        item = line.strip
        if ( item =~ /[\W]+/ )
          raise ArgumentError, Puppet::Type::Brocade_messages::ZONE_NAME_SPECIAL_CHAR_ERROR
        end
      end
    end
  end

end
