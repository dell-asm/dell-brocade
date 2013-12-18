Puppet::Type.newtype(:brocade_zone) do
  @doc = "This represents a zone on a brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name"
    isnamevar
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid zone name."
      end
    end
  end

  newparam(:member) do
    desc "memeber added in the zone"
    newvalues(/^\S+$/)

    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid zone name."
      end
    end
  end

  newparam(:zoneconfig) do
    desc "zonecofig in which zone has to be added"
    newvalues(/^\S+$/)
  end

end
