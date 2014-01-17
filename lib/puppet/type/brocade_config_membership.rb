require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_config_membership) do
  @doc = "This represents a zone config membership on a brocade switch."

  apply_to_device

  ensurable
  newparam(:name, :namevar => true) do
    desc "Brocade configname:member_zone name."

    munge do |value|
      @resource[:configname], @resource[:member_zone] = value.split(':',2)
      value
    end
  end

  newparam(:configname) do
    desc "This parameter describes the config name on Brocade
    The valid config name does not allow blank value,special character except _ ,numeric char at the start, and length above 64 chars"

    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.special_char_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_SPECIAL_CHAR_ERROR)
      Puppet::Type::Brocade_messages.numeric_char_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_NUMERIC_CHAR_ERROR)
      Puppet::Type::Brocade_messages.long_name_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_LONG_ERROR)
    end
  end

  newparam(:member_zone) do
    desc "This parameter describes the zone to be added in the config
          The valid zone name does not allow blank value,special character except _ ,numeric char at the start, and length above 64 chars"
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.list_special_char_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_SPECIAL_CHAR_ERROR)
      Puppet::Type::Brocade_messages.numeric_char_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_NUMERIC_CHAR_ERROR)
      Puppet::Type::Brocade_messages.long_name_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_LONG_ERROR)
    end
  end

end
