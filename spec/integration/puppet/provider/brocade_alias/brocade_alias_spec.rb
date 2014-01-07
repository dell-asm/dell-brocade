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

  let :dummy_alias do
    Puppet::Type.type(:brocade_alias).new(
      :alias_name  => 'testalias2',
      :ensure   => 'present',
      :member   => '0f:0a:0a:0a:0a:0a:0a:0a',
    )
  end
  
  let :type_provider do
    dummy_alias.provider
  end
  
  before :each do
    type_provider.device_transport.connect  
  end

  context "when create and delete alias without any error" do
    it "should be create a brocade alias" do     
      response = type_provider.create
    end
    
    it "should delete the brocade alias" do     
      response = type_provider.destroy
    end
  end

end

