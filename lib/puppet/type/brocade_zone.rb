require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_zone) do
  @doc = "This represents a zone on a brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "This parameter describes the zone name to be created on the Brocade.
          The valid zone name does not allow blank value, special character except _ ,numeric char at the start, and length above 64 chars"
    isnamevar
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.special_char_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_SPECIAL_CHAR_ERROR)
      Puppet::Type::Brocade_messages.numeric_char_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_NUMERIC_CHAR_ERROR)
      Puppet::Type::Brocade_messages.long_name_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_LONG_ERROR)
    end
  end

  newparam(:member) do
    desc "This parameter describes/displays the member to be added on the Brocade. 
         The valid member format either has alias name or wwpn format of xx:xx:xx:xx:xx:xx:xx:xx. 
		Alias name does not allow blank value,special character except _ ,numeric char at the start, and length above 64 chars"
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.member_value_format_check(value)
    end
  end

end
