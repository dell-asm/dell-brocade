class Brocade_alias_fixture

  attr_accessor :brocade_alias, :provider

  def initialize
    @brocade_alias = get_brocade_alias
	@provider = brocade_alias.provider	
  end
  
  private 
  def  get_brocade_alias
    Puppet::Type.type(:brocade_alias).new(
    :alias_name => 'DemoAlias',
    :ensure => 'present',
    :member => '0f:0a:0a:0a:0a:0a:0a:0a'
	)
  end
  
  public
  def get_alias_name
    brocade_alias[:alias_name]
  end
  
  def get_member_name
    brocade_alias[:member]
  end
end
