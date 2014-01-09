class Brocade_config_membership_fixture

  attr_accessor :brocade_config_membership, :provider
  def initialize
    @brocade_config_membership = get_brocade_config_membership
    @provider = brocade_config_membership.provider
  end

  private

  def  get_brocade_config_membership
    Puppet::Type.type(:brocade_config_membership).new(
    :name => 'DemoConfig:DemoZone1;DemoZone2',
    :ensure => 'present',
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
    :name => 'DemoConfig:DemoZone1;DemoZone2',
    :ensure => 'absent',
    )
  end

end