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
    end
  end

  newparam(:member) do
    desc "This parameter describes/displays the member to be added on the Brocade switch."
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Unable to perform the operation because the member name is invalid."
      end
    end
  end

  newparam(:zoneconfig) do
    desc "This parameter describes the zone configuration where the zone is to be added."
    newvalues(/^\S+$/)
  end

end
