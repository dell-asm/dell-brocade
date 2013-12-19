Puppet::Type.newtype(:brocade_manage_zone) do
  @doc = "This represents a Addition of Member to zone Created on brocade switch."

  apply_to_device

  ensurable

  newparam(:zonename) do
    desc "Zone name"
    isnamevar
    newvalues(/^\S+$/)
  end

  newparam(:member) do
    desc "Member Name"
    newvalues(/^\S+$/)
  end

  newparam(:configname) do
    desc "Zone name"
    newvalues(/^\S+$/)
 end

end

