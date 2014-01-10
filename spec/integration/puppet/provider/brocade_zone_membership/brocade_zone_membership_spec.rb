#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'

describe "Integration test for brocade zone membership" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
  end

  let :zone_add_member do
    Puppet::Type.type(:brocade_zone_membership).new(
    :zonename    => 'testZone',
    :ensure      => 'present',
    :member      => '50:00:d3:10:00:5e:c4:3b',
    )
  end

  let :zone_delete_member do
    Puppet::Type.type(:brocade_zone_membership).new(
    :zonename    => 'testZone',
    :ensure      => 'absent',
    :member      => '50:00:d3:10:00:5e:c4:3b',
    )
  end
  
    let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename     => 'testZone',
    :ensure   => 'present',
    :member => '50:00:d3:10:00:5e:c4:3a',
    )
  end
    let :destroy_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename => 'testZone',
    :ensure   => 'absent',
    )
  end
    
  
  before :each do
    puts "Creating Zone before Test"
    create_zone.provider.device_transport.connect
    create_zone.provider.create
    create_zone.provider.device_transport.close
  end

  after :each do
    puts "Delete Zone after Test"
    destroy_zone.provider.device_transport.connect
    destroy_zone.provider.destroy
    destroy_zone.provider.device_transport.close
  end

  context "should add and remove member to a zone" do
    it "should should add a member to a zone" do
      zone_add_member.provider.device_transport.connect
      zone_add_member.provider.create
      zone_show_res = zone_add_member.provider.device_transport.command(get_zone_show_cmd(zone_add_member[:zonename]),:noop=>false)
      zone_add_member.provider.device_transport.close
      presense?(zone_show_res,zone_add_member[:member]).should == true
    end

    it "should delete a member from a zone" do
      zone_delete_member.provider.device_transport.connect
      zone_delete_member.provider.destroy
      zone_show_res = zone_delete_member.provider.device_transport.command(get_zone_show_cmd(zone_delete_member[:zonename]),:noop=>false)
      zone_delete_member.provider.device_transport.close
      presense?(zone_show_res,zone_delete_member[:member]).should_not == true
    end
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

  def get_zone_show_cmd(zonename)
    command = "zoneshow #{zonename}"
  end
end
