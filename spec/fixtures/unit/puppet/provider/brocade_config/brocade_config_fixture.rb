class Brocade_config_fixture

  attr_accessor :brocade_config, :provider
  def initialize
    @brocade_config = get_brocade_config
    @provider = brocade_config.provider
  end

  private

  def  get_brocade_config
    Puppet::Type.type(:brocade_config).new(
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

  def set_configstate_enable
    brocade_config[:configstate] = 'enable'
  end

  def set_config_ensure_absent
    brocade_config[:ensure] = 'absent'
  end
end