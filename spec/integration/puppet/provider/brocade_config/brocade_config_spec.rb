#! /usr/bin/env ruby
require 'spec_helper'
require 'yaml'
require 'spec_lib/puppet_spec/deviceconf'
include PuppetSpec::Deviceconf

describe "Integratin test for create Config in enable and disable mode and destroy Config" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stub(:value).with(:url).and_return(device_conf['url'])
  end

  let :create_config_disable do
    Puppet::Type.type(:brocade_config).new(
    :configname    => 'DemoConfig',
    :configstate   => 'disable',
    :member_zone   => 'DemoZone25'
    )
  end
  
  let :create_config_enable do
    Puppet::Type.type(:brocade_config).new(
    :configname    => 'DemoConfig',
    :configstate   => 'enable',
    :member_zone   => 'DemoZone25'
    )
  end

  let :destroy_config do
    Puppet::Type.type(:brocade_config).new(
    :configname  => 'DemoConfig',
    )
  end

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename     => 'DemoZone25',
    :ensure   => 'present',
    :member => '50:00:d3:10:00:5e:c4:35',
    )
  end

  let :destroy_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename => 'DemoZone25',
    :ensure   => 'absent',
    )
  end

  let :config_enable do
    Puppet::Type.type(:brocade_config).new(
    :ensure      => 'present',
    :configname  => 'Top_Config',
    :configstate => 'enable',
    )
  end

  ##Zone Creating, before each test case execution
  before :each do
    puts "Creating Zone before Test"
    create_zone.provider.device_transport.connect
    create_zone.provider.create
    create_zone.provider.device_transport.close
  end
  
  ##Zone Destroy, after each test case execution
  after :each do
    puts "Delete Zone after Test"
    destroy_zone.provider.device_transport.connect
    destroy_zone.provider.destroy
    destroy_zone.provider.device_transport.close
  end


  context "should create Config in enable and disable mode and destroy config" do
    it "should create a brocade config in disabled mode" do  
        
      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      destroy_config.provider.device_transport.close
       
      create_config_disable.provider.device_transport.connect
      create_config_disable.provider.create
      create_config_res = create_config_disable.provider.device_transport.command(get_brocade_cfgshow_command(create_config_disable[:configname]),:noop=>false)
      create_config_disable.provider.device_transport.close
      
      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      destroy_config.provider.device_transport.close
      puts "CreateConfigDisable--#{create_config_res}"
      create_config_res.should_not include("does not exist")
    end
  
    it "should create a brocade config in enabled mode" do

      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      destroy_config.provider.device_transport.close

      create_config_enable.provider.device_transport.connect
      create_config_enable.provider.create
      create_config_res = create_config_enable.provider.device_transport.command(get_brocade_cfgactvshow_command,:noop=>false)
      create_config_enable.provider.device_transport.close
      ##We have created a config in the enable mode, now we will enable the
      ##config which was earlier enabled so that we can delete the currently created config

      config_enable.provider.device_transport.connect
      config_enable.provider.configstate=(:enable)
      tempRes=  config_enable.provider.device_transport.command("cfgactvshow",:noop=>false)
      config_enable.provider.device_transport.close

      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      destroy_config.provider.device_transport.close
      presense?(create_config_res,create_config_enable[:configname]).should == true
    end


    it "should delete the brocade config" do
      create_config_disable.provider.device_transport.connect
      create_config_disable.provider.create
      create_config_disable.provider.device_transport.close
      
      destroy_config.provider.device_transport.connect
      destroy_config.provider.destroy
      response = destroy_config.provider.device_transport.command(get_brocade_cfgshow_command(destroy_config[:configname]),:noop=>false)
      destroy_config.provider.device_transport.close
      response.should include("does not exist")
    end
  end

  def get_brocade_cfgshow_command(configname)
    command = "cfgshow #{configname}"
  end

  def get_brocade_cfgactvshow_command
    command = "cfgactvshow"
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
  
end