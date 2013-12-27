require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_config) do
  @doc = "This represents a zone config on a brocade switch."

  apply_to_device

  ensurable do 
    desc "Config ensure property"
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do 
      provider.destroy
    end
  end

  newparam(:configname) do
    desc "This parameter describes the config name on Brocade"
    isnamevar
    validate do |value|
      Puppet::Type::Brocade_messages.empty_value_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_BLANK_ERROR)
      Puppet::Type::Brocade_messages.special_char_check(value, Puppet::Type::Brocade_messages::CONFIG_NAME_SPECIAL_CHAR_ERROR)
    end
  end

  newparam(:member_zone) do
    desc "This parameter describes the zone in the config"
    #newvalues(/^\S+$/)
  end

  newproperty(:configstate) do
    desc "This parameter describes the config state"
    newvalues(:enable, :disable)
  end


end
