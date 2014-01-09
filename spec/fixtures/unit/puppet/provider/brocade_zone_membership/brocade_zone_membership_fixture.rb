class Brocade_zone_membership_fixture

  attr_accessor :brocade_zone_membership, :provider
  def initialize
    @brocade_zone_membership = get_brocade_zone_membership
    @provider = brocade_zone_membership.provider
  end

  private

  def  get_brocade_zone_membership
    Puppet::Type.type(:brocade_zone_membership).new(
    :zonename => 'DemoZone',
    :ensure => 'present',
    :member => 'DemoMember',
    )
  end

end

class Brocade_zone_membership_fixture_with_absent

  attr_accessor :brocade_zone_membership, :provider
  def initialize
    @brocade_zone_membership = get_brocade_zone_membership
    @provider = brocade_zone_membership.provider
  end

  private

  def  get_brocade_zone_membership
    Puppet::Type.type(:brocade_zone_membership).new(
    :zonename => 'DemoZone',
    :ensure => 'absent',
    :member => 'DemoMember',
    )
  end

end