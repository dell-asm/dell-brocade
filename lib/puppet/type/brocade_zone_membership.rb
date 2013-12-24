Puppet::Type.newtype(:brocade_zone_membership) do
  @doc = "This represents a Addition and removal of Member to/from existing zone on brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name"
    isnamevar
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Zone name can not be blank."
      end
end
  end

  newparam(:member) do
    desc "Member Name"
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Member Zone name can not be blank."
      end
end
  end

end

