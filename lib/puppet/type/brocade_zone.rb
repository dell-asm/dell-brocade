Puppet::Type.newtype(:brocade_zone) do
  @doc = "This represents a zone on a brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name"
    isnamevar
    newvalues(/^\S+$/)
  end

  newparam(:member) do
    desc "memeber added in the zone"
    newvalues(/^\S+$/)
  end


end

