require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_zone_membership) do
  @doc = "This represents a Addition and removal of Member to/from existing zone on brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name"
    isnamevar
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_BLANK_ERROR)
	  Puppet::Type::Brocade_messages.special_char_check(value, Puppet::Type::Brocade_messages::ZONE_NAME_SPECIAL_CHAR_ERROR)
    end
  end

  newparam(:member) do
    desc "Member Name"
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::ALIAS_NAME_BLANK_ERROR)
	  Puppet::Type::Brocade_messages.tokenize_list(value).each do |line|
        Puppet::Type::Brocade_messages.member_wwpn_format_check(line.strip, Puppet::Type::Brocade_messages::MEMBER_WWPN_INVALID_FORMAT_ERROR) 
      end		
    end
  end

end

