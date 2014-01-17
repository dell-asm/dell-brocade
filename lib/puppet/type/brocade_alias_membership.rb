require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_alias_membership) do
  @doc = "This represents an alias name for a member on a brocade switch."

  apply_to_device

  newparam(:name, :namevar => true) do
    desc "This parameter is tuple of alias name and member perameter"

    munge do |value|
      @resource[:alias_name], @resource[:member] = value.split(':',2)
      value
    end
  end

  ensurable

  newparam(:alias_name) do
    desc "This parameter describes the Brocade alias name for the MemberWWPN.
          The valid alias name does not allow blank value, special character except _ ,numeric char at the start, and length above 64 chars"
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.special_char_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_SPECIAL_CHAR_ERROR)
      Puppet::Type::Brocade_messages.numeric_char_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_NUMERIC_CHAR_ERROR)
      Puppet::Type::Brocade_messages.long_name_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_LONG_ERROR)
    end
  end

  newparam(:member) do
    desc "This parameter describes the MemberWWPN value whose alias is to be updated.
          The valid member value has a valid format of xx:xx:xx:xx:xx:xx:xx:xx and does not allow blank value"
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::MEMBER_WWPN_BLANK_ERROR)
      Puppet::Type::Brocade_messages.tokenize_list(value).each do |line|
        Puppet::Type::Brocade_messages.member_wwpn_format_check(line.strip, Puppet::Type::Brocade_messages::MEMBER_WWPN_INVALID_FORMAT_ERROR)
      end
    end
  end

end
