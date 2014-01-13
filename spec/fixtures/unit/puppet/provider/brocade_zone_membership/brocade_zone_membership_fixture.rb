class Brocade_zone_membership_fixture

  attr_accessor :brocade_zone_membership, :provider
  def initialize
    @brocade_zone_membership = get_brocade_zone_membership
    @provider = brocade_zone_membership.provider
  end

  def  get_brocade_zone_membership
    Puppet::Type.type(:brocade_zone_membership).new(
    :zonename => 'DemoZone',
    :ensure => 'present',
    :member => 'DemoMember',
    )
  end

  def get_zone_name
    @brocade_zone_membership[:zonename]
  end

  def get_member_name
    @brocade_zone_membership[:member]
  end

  def  get_ensure_value
    @brocade_zone_membership[:ensure]
  end

  def  set_ensure_value_absent
    @brocade_zone_membership[:ensure] = 'absent'
  end

end