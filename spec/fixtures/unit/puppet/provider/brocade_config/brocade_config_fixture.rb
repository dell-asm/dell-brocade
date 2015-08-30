class Brocade_config_fixture

  attr_accessor :brocade_config, :provider
  def initialize
    @brocade_config = get_brocade_config
    @provider = brocade_config.provider
  end

  private

  def  get_brocade_config
    Puppet::Type.type(:brocade_config).new(
        :name => 'zonename:DemoConfig',
        :configname => 'DemoConfig',
        :ensure => 'present',
        :member_zone => 'DemoZone',
        :configstate => 'disable',
    )
  end

  public

  def get_config_name
    brocade_config[:configname]
  end

  def get_config_state
    brocade_config[:configstate]
  end

  def get_member_zone
    brocade_config[:member_zone]
  end

  def set_configstate_enable
    brocade_config[:configstate] = 'enable'
  end

  def set_config_ensure_absent
    brocade_config[:ensure] = 'absent'
  end
end

