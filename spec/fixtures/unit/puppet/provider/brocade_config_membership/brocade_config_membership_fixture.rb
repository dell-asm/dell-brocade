class Brocade_config_membership_fixture

  attr_accessor :brocade_config_membership, :provider
  def initialize
    @brocade_config_membership = get_brocade_config_membership
    @provider = brocade_config_membership.provider
  end

  def  get_brocade_config_membership
    Puppet::Type.type(:brocade_config_membership).new(
    :name => 'DemoConfig:DemoZone1;DemoZone2',
    :ensure => 'present',
    :member_zone => 'DemoZone',
    :configname => 'DemoConfig',
    )
  end

  def  get_config_name
    @brocade_config_membership[:configname]
  end

  def  get_member_zone_name
    @brocade_config_membership[:member_zone]
  end

  def  get_ensure_value
    @brocade_config_membership[:ensure]
  end

  public

  def set_brocade_config_membership_ensure_absent
    @brocade_config_membership[:ensure] = 'absent'
  end
end