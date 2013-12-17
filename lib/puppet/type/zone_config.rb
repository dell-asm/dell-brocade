Puppet::Type.newtype(:zone_config) do
  @doc = "This represents a zone config on a brocade switch."

  apply_to_device

  ensurable

  newparam(:configname) do
    desc "Config name"
    isnamevar
    newvalues(/^\S+$/)
  end

  newproperty(:member_zone) do
    desc "zone added in the config"
    newvalues(/^\S+$/)
  end

end
