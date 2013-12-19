Puppet::Type.newtype(:brocade_zone) do
  @doc = "This represents a zone on a brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name to be created on the Brocade Switch"
    isnamevar
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid zone name."
      end
    end
  end

  newparam(:member) do
    desc "Member to be added in the zone on the Brocade Switch"
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid member name."
      end
    end
  end

  newparam(:zoneconfig) do
    desc "Zoneconfig in which zone is to be added"
    newvalues(/^\S+$/)
  end

end
