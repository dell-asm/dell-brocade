#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'rspec/expectations'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/util/network_device/transport_fos/ssh'


describe Puppet::Type.type(:brocade_zone).provider(:brocade_zone) do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
  end

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
      :zonename     => 'testZone25',
      :ensure   => 'present',
      :member	=> 'testMember',
    )
  end
  
  let :destroy_zone do
    Puppet::Type.type(:brocade_zone).new(
      :zonename => 'testZone25',
      :ensure   => 'absent',
    )
  end
  
  context "#create" do
    
   it "should create a brocade zone" do
      type = create_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      type_provider.create
      response = type_provider.device_transport.command(get_zoneshow,:noop=>false)
      #puts "Create:: #{response}"
      expect {response.should include("does not exist")
      }.to raise_error
    end

    it "should destroy a brocade zone" do
      type = destroy_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      type.provider.destroy
      response = type_provider.device_transport.command(get_zoneshow,:noop=>false)
      #puts "Destroy:: #{response}"
      expect {response.should_not include("does not exist")
      }.to raise_error
    end

    
  end   
  
  def get_zoneshow
    command = "zoneshow #{create_zone[:zonename]}"
  end  
end
