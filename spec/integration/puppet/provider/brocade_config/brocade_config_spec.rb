#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'

describe "Integration Testing for Brocade config" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
  end

  let :create_config_disable do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'Top_Config',
    :configstate   => 'disable',
    :member_zone   => 'DemoZone31'
    )
  end
  let :create_config_enable do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'Top_Config',
    :configstate   => 'enable',
    :member_zone   => 'DemoZone31'
    )
  end

  let :destroy_config do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'DemoConfig',
    )
  end

  context "when create and delete config without any error" do
    it "should be able to create a brocade config" do
      create_config_disable.provider.device_transport.connect
      create_config_disable.provider.create
      response = create_config_disable.provider.device_transport.command(get_brocade_config_show_command(create_config_disable[:configname]),:noop=>false)
      response.should_not include("does not exist")
      create_config_disable.provider.device_transport.close
    end

    it "should create a brocade config and enable the config" do
      create_config_enable.provider.device_transport.connect
      create_config_enable.provider.create
      response = create_config_enable.provider.device_transport.command(get_brocade_config_show_command(create_config_enable[:configname]),:noop=>false)
      response.should_not include("does not exist")
      verify_config_enabled
      create_config_enable.provider.device_transport.close
    end

    it "should delete the brocade config" do
      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      response = destroy_config.provider.device_transport.command(get_brocade_config_show_command(destroy_config[:configname]),:noop=>false)
      response.should include("does not exist")
      destroy_config_enable.provider.device_transport.close
    end
  end

  def get_brocade_config_show_command(configname)
    command = "cfgshow #{configname}"
  end

  def get_brocade_zone_show_command
    command = "cfgactvshow"
  end

  def verify_config_enabled
    response = String.new("")
    #response =  @device.transport.command("zoneshow", :noop => false)
    response = create_config_enable.provider.device_transport.command(get_brocade_zone_show_command,:noop=>false)
    match1 = /cfg:\s*(\S+)?/.match(response)

    if !$1.empty?
      effectiveConfiguration = $1
      config = create_config_enable[:configname]
      "#{effectiveConfiguration}".should include("#{config}")
      if config == effectiveConfiguration
        #enableZoneConfig
        puts("Verified config #{config} enabled successfully")
      end
    end
  end
end

