#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'


describe "Brocade config testing" do
  
  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do    
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    #described_class.stubs(:suitable?).returns true    
  end

  let :add_zone_config do
    Puppet::Type.type(:brocade_config_membership).new(
      :configname  => 'DemoConfig123',
      :member_zone   => 'DemoZone31',
      :ensure => 'present'
    )
  end
  let :remove_zone_config do
   Puppet::Type.type(:brocade_config_membership).new(
      :configname  => 'DemoConfig123',
      :member_zone   => 'DemoZone31',
	  :ensure => 'absent'
  )
  end
  
   context "when add and remove zone from config without any error" do
    it "should add zone to config" do
      add_zone_config.provider.device_transport.connect
      add_zone_config.provider.create
      response = add_zone_config.provider.device_transport.command(get_brocade_config_show_command(add_zone_config[:configname]),:noop=>false)
      response.should include(add_zone_config[:configname])
    end

     it "should remove the zone from config" do
       remove_zone_config.provider.device_transport.connect
       remove_zone_config.provider.destroy
       response = remove_zone_config.provider.device_transport.command(get_brocade_config_show_command(remove_zone_config[:configname]),:noop=>false)
      response.should_not include(remove_zone_config[:configname])
     end
  end

  def get_brocade_config_show_command(configname)
    command = "cfgshow #{configname}"
  end

end
