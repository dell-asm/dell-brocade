#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'
require 'rspec/mocks'
require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'puppet/util/network_device/transport_fos/ssh'


describe Puppet::Type.type(:brocade_alias).provider(:brocade_alias), '(integration)' do
  
  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do    
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    described_class.stubs(:suitable?).returns true    
  end

  let :create_alias do
    Puppet::Type.type(:brocade_alias).new(
      :alias_name     => 'testalias11',
      :ensure   => 'present',
      :member   => '0f:0a:0a:0a:0a:0a:0a:0a',
    )
  end

  let :create_provider do
    described_class.new()
  end

  context "test for create and delete alias" do
    it "should create a brocade alias" do
      type = create_alias
      type_provider = type.provider
      type_provider.device_transport.connect
      response = type_provider.create
    end
  end

end

