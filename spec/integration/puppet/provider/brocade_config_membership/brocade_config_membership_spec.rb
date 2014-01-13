#! /usr/bin/env ruby
require 'spec_helper'
require 'yaml'
require 'spec_lib/puppet_spec/deviceconf'
include PuppetSpec::Deviceconf

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
    :name  => 'DemoConfig:DemoNewZone',
    :ensure => 'present'
    )
  end

  let :remove_zone_config do
    Puppet::Type.type(:brocade_config_membership).new(
    :name  => 'DemoConfig:DemoNewZone',
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
    Facter.stub(:value).with(:url).and_return(device_conf['url'])
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
      zone_name = get_zone_name(add_zone_config[:name])
      add_zone_config.provider.device_transport.close
      puts "Create - Checking presense of zone_name #{zone_name} in CFG -#{response} "
      presense?(response,zone_name).should == true
    end

    it "should be able to remove the zone from config" do
      remove_zone_config.provider.device_transport.connect
      remove_zone_config.provider.destroy
      response = remove_zone_config.provider.device_transport.command(get_brocade_config_show_command(remove_zone_config[:configname]),:noop=>false)
      zone_name = get_zone_name(remove_zone_config[:name])
      remove_zone_config.provider.device_transport.close
      puts "Destroy - Checking presense of zone_name #{zone_name} in CFG -#{response} "
      presense?(response,zone_name).should_not == true
    end
  end

  def get_brocade_config_show_command(configname)
    command = "cfgshow #{configname}"
  end

  def presense?(response_string,key_to_check)
    retval = false
    if response_string.include?("#{key_to_check}")
    retval = true
    else
    retval = false
    end
    return retval
  end

  def get_zone_name(inputString)
    member = inputString.split(':')
    return member[1]
  end

end
