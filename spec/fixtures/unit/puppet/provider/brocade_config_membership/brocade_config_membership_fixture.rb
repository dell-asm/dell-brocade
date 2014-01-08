class Brocade_config_membership_fixture

  attr_accessor :brocade_config_membership, :provider
  def initialize
    @brocade_config_membership = get_brocade_config_membership
    @provider = brocade_config_membership.provider
  end

  private

  def  get_brocade_config_membership
    Puppet::Type.type(:brocade_config_membership).new(
    :configname => 'DemoConfig',
    :ensure => 'present',
    :member_zone => 'DemoZone',
    )
  end

end

class Brocade_config_membership_fixture_with_absent

  attr_accessor :brocade_config_membership, :provider
  def initialize
    @brocade_config_membership = get_brocade_config_membership
    @provider = brocade_config_membership.provider
  end

  private

  def  get_brocade_config_membership
    Puppet::Type.type(:brocade_config_membership).new(
    :configname => 'DemoConfig',
    :ensure => 'absent',
    :member_zone => 'DemoZone',
    )
  end

end