Puppet::Type.newtype(:brocade_config) do
  @doc = "This represents a zone config on a brocade switch."

  apply_to_device

  ensurable do 
    desc "<<<<<<<<<<<<<<<<<"
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do 
      provider.destroy
    end
  end

  newparam(:configname) do
    desc "Config name"
    isnamevar
    newvalues(/^\S+$/)
  end

  newproperty(:member_zone) do
    desc "zone added in the config"
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Member Zone name can not be blank."
      end
    end
  end

  newproperty(:configstate) do
    desc "config state"
    newvalues(:enable, :disable)
  end


end
