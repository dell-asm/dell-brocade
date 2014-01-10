#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'

describe "Integration Testing for Brocade config" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  let :create_config do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'DemoConfig',
    :member_zone   => 'DemoZone',
    )
  end

  let :add_zone_config do
    Puppet::Type.type(:brocade_config_membership).new(
    :configname  => 'DemoConfig',
    :member_zone   => 'DemoNewZone',
    :ensure => 'present'
    )
  end

  let :remove_zone_config do
    Puppet::Type.type(:brocade_config_membership).new(
    :configname  => 'DemoConfig',
    :member_zone   => 'DemoNewZone',
    :ensure => 'absent'
    )
  end
  let :destroy_config do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'DemoConfig',
    )
  end

#Before every test config will be created
  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    create_config.provider.device_transport.connect
    create_config.provider.create
    create_config.provider.device_transport.close
  end

#After every test config will be destroyed
  after :each do
    destroy_config.provider.device_transport.connect
    destroy_config.provider.destroy
    destroy_config.provider.device_transport.close
  end

  context "when add and remove zone from config without any error" do
    it "should be able to add zone to config" do
      add_zone_config.provider.device_transport.connect
      add_zone_config.provider.create
      response = add_zone_config.provider.device_transport.command(get_brocade_config_show_command(add_zone_config[:configname]),:noop=>false)
      response.should include(add_zone_config[:member_zone])
      add_zone_config.provider.device_transport.close

    end

    it "should be able to remove the zone from config" do
      add_zone_config.provider.device_transport.connect
      add_zone_config.provider.create
      add_zone_config.provider.device_transport.close
      remove_zone_config.provider.device_transport.connect
      remove_zone_config.provider.destroy
      response = remove_zone_config.provider.device_transport.command(get_brocade_config_show_command(remove_zone_config[:configname]),:noop=>false)
      response.should_not include(remove_zone_config[:member_zone])
      remove_zone_config.provider.device_transport.close
    end
  end

  def get_brocade_config_show_command(configname)
    command = "cfgshow #{configname}"
  end

  def get_brocade_zone_show_command
    command = "cfgactvshow"
  end

end
