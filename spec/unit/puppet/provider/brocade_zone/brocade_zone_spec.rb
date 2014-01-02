#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/equallogic'
require 'puppet/util/network_device/equallogic/device'

describe Puppet::Type.type(:brocade_zone).provider(:brocade_zone) do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))
  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    described_class.stubs(:suitable?).returns true
    Puppet::Type.type(:brocade_zone).stubs(:defaultprovider).returns described_class
  end

  create_zone_yml =  YAML.load_file(my_fixture('create_zone.yml'))
  create_node1 = create_zone_yml['CreateVolume1']  

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
		:zonename => create_node1['zonename'],
		:member => create_node1['member'],
		:ensure   => create_node1['ensure'],
    )
  end

  
  describe "when asking exists?" do
    it "should return true if resource/volume is present" do
      create_zone.provider.set(:ensure => :present)
      create_zone.provider.should be_exists
    end

  describe "when creating a new volume - with unique name" do
    it "should be able to create a volume" do
      create_zone.provider.create
    end
  end

  describe "when creating a new volume - with name already exists" do
    it "should not be allowed to create a volume with duplicate name" do
      create_zone.provider.create
    end
  end

end
