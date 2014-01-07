class Brocade_alias_membership_fixture

  attr_accessor :brocade_alias_membership, :provider
  def initialize
    @brocade_alias_membership = get_brocade_alias_membership
    @provider = brocade_alias_membership.provider
  end

  private

  def  get_brocade_alias_membership
    Puppet::Type.type(:brocade_alias_membership).new(
    :alias_name => 'DemoAlias',
    :ensure => 'present',
    :member => '0f:0f:0f:0f:0f:0f:0f:0f ',
    )
  end

 end