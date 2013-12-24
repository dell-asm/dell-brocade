[root@puppet-centos type]# vi brocade_config_membership.rb
Puppet::Type.newtype(:brocade_config_membership) do
  @doc = "This represents a zone config membership on a brocade switch."

  apply_to_device

  ensurable do
    desc "config zone addition, removal ensure property."
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
    newvalues(/[\w]+/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Enter a valid Config name value."
      end
      if ( value =~ /[\W]+/ )
        raise ArgumentError, "Brocade does not support special characters in Config name."
      end
    end
  end

  newproperty(:member_zone) do
    desc "zone added in the config"
    newvalues(/^\S+$/)
    value.split(";").each do |line|
      item = line.strip
      if ( item =~ /[\W]+/ )
        raise ArgumentError, "Brocade does not support special characters in Zone name."
      end
    end
  end

end
