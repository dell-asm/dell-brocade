#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/util/network_device/transport_fos/ssh'
require 'puppet/spec/integrations/provider'


describe Puppet::Type.type(:brocade_zone).provider(:brocade_zone) do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    described_class.stubs(:suitable?).returns true
    Puppet::Type.type(:brocade_zone).stubs(:defaultprovider).returns described_class
  end

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
      :zonename     => 'testZone25',
      :ensure   => 'present',
      :member	=> 'testMember',
    )
  end

  let :create_provider do
    described_class.new()
  end 

  context "#create" do
    it "should create a brocade zone" do
      type = create_zone
      type_provider = type.provider
      type_provider.device_transport.connect
    end
  end 
end

