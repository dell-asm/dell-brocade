class Brocade_zone_fixture

  attr_accessor :brocade_zone, :provider

  def initialize
    @brocade_zone = get_brocade_zone	
	@provider = brocade_zone.provider	
	end
  
  private 
  def  get_brocade_zone
    Puppet::Type.type(:brocade_zone).new(
    :zonename => 'DemoZone',
    :member => 'DemoMember',
	    )
  end
  
  public
  def get_zone_name
    brocade_zone[:zonename]
  end
  
end