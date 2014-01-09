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
      :configstate   => 'disable'
  )
  end
  
  context "when create and delete config without any error" do
    it "should create a brocade config" do  
      create_config_disable.provider.device_transport.connect  
      create_config_disable.provider.create
      response = create_config_disable.provider.device_transport.command(get_brocade_config_show_command(create_config_disable[:configname]),:noop=>false)
      response.should_not include("does not exist")        
    end
    it "should create a brocade config and enable the config" do
      create_config_enable.provider.device_transport.connect
      create_config_enable.provider.create
      response = create_config_enable.provider.device_transport.command(get_brocade_config_show_command(create_config_enable[:configname]),:noop=>false)
      response.should_not include("does not exist")
	getEffectiveConfiguration
    end

    # it "should delete the brocade alias" do     
      # destroy_alias.provider.device_transport.connect  
      # destroy_alias.provider.destroy
      # response = destroy_alias.provider.device_transport.command(get_alias_show_cmd(create_alias[:alias_name]),:noop=>false)
      # response.should include("does not exist")   
    # end
  end

  def get_brocade_config_show_command(configname)
    command = "cfgshow #{configname}"
  end
   def get_brocade_zone_show_command
    command = "cfgactvshow"
  end
 
def getEffectiveConfiguration
    response = String.new("")
    response = create_config_enable.provider.device_transport.command(get_brocade_zone_show_command,:noop=>false)
	match1 = /cfg:\s*(\S+)?/.match(response)
	puts("got match" + $1 + "##############################")
	if !$1.empty?
    effectiveConfiguration = $1
	config = create_config_enable[:configname]
	puts("#{config} and #{effectiveConfiguration}")
    "#{effectiveConfiguration}".should include("#{config}")
    if config == effectiveConfiguration
	puts("config #{config} enable successfully")
	end
	end
end
end

