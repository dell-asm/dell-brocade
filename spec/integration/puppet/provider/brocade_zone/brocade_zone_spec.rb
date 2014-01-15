#! /usr/bin/env ruby
require 'spec_helper'
require 'yaml'
require 'spec_lib/puppet_spec/deviceconf'
include PuppetSpec::Deviceconf

describe "Integration test for brocade zone create and destroy" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))
  before :each do
    Facter.stub(:value).with(:url).and_return(device_conf['url'])
  end

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename     => 'testZone25',
    :ensure   => 'present',
    :member => 'testMember',
    )
  end

  let :destroy_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename => 'testZone25',
    :ensure   => 'absent',
    )
  end

  def get_zoneshow_cmd(zonename)
    command = "zoneshow #{zonename}"
  end
  
  

  context "should Create and Destroy Zone" do
    it "should create a brocade zone" do
      destroy_zone.provider.device_transport.connect
      destroy_zone.provider.destroy
      destroy_zone.provider.device_transport.close
      
      create_zone.provider.device_transport.connect
      create_zone.provider.create
      create_response = create_zone.provider.device_transport.command(get_zoneshow_cmd(create_zone[:zonename]),:noop=>false)
      create_zone.provider.device_transport.close
      
      destroy_zone.provider.device_transport.connect
      destroy_zone.provider.destroy
      destroy_zone.provider.device_transport.close
      
      create_response.should_not include("does not exist")
    end

    it "should be able to destroy a brocade zone" do
      create_zone.provider.device_transport.connect
      create_zone.provider.create
      create_zone.provider.device_transport.close

      destroy_zone.provider.device_transport.connect
      destroy_zone.provider.destroy
      destroy_response = destroy_zone.provider.device_transport.command(get_zoneshow_cmd(destroy_zone[:zonename]),:noop=>false)
      destroy_response.should include("does not exist")
    end

  end
end
