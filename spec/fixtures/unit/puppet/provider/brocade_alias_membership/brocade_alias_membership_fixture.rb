class Brocade_alias_membership_fixture

  attr_accessor :brocade_alias_membership, :provider
  def initialize
    @brocade_alias_membership = get_brocade_alias_membership
    @provider = brocade_alias_membership.provider
  end

  private

  def  get_brocade_alias_membership
    Puppet::Type.type(:brocade_alias_membership).new(
    :name => 'DemoAlias:0f:0f:0f:0f:0f:0f:0f:0f ',
    :ensure => 'present'
    )
  end

public
  def  get_alias_name
    @brocade_alias_membership[:alias_name]
  end
  
  def  get_member_name
    @brocade_alias_membership[:member]
  end


  def  get_ensure_value
    @brocade_alias_membership[:ensure]
  end
  
  def  set_ensure_value_absent
    @brocade_alias_membership[:ensure] = 'absent'
  end

end