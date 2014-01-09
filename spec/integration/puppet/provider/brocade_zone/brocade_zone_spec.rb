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
      :member => 'testMember',
    )
  end

  let :destroy_zone do
    Puppet::Type.type(:brocade_zone).new(
      :zonename => 'testZone25',
      :ensure   => 'absent',
    )
  end
  
  def get_zoneshow
    command = "zoneshow #{create_zone[:zonename]}"
  end   

  context "Create and Destroy Zone" do
    it "should create a brocade zone" do
      type = destroy_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      ##Initially check the presense of the zone,if exist destroy the existing zone
      ##and continue the create zone feature of the brocade_zone provider.
      zone_show_res = type_provider.device_transport.command(get_zoneshow,:noop=>false)
      zone_absent = presense?(zone_show_res,"does not exist")
      if zone_absent == false
        ##if zone already exist, will delete the zone and continue with the test.
        zone_del_res = type_provider.device_transport.command("zonedelete #{create_zone[:zonename]}",:noop=>false)
        cfg_save_res =  type_provider.device_transport.command("cfgsave", :prompt => /Do/)
        if cfg_save_res.match(/fail|err|not found|not an alias/)
          puts "Unable to save the Config because of the following issue: #{cfg_save_res}"
        else
          puts "Successfully saved the Config"
        end
      end 
      type_provider.device_transport.close
      type = create_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      type_provider.create
      create_response = type_provider.device_transport.command(get_zoneshow,:noop=>false)
      type_provider.device_transport.close
      create_response.should_not include("does not exist")
    end
    
    it "should destroy a brocade zone" do
      type = create_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      type.provider.create

      type_provider.device_transport.close

      type = destroy_zone
      type_provider = type.provider
      type_provider.device_transport.connect
      type.provider.destroy
      destroy_response = type_provider.device_transport.command(get_zoneshow,:noop=>false)
      destroy_response.should include("does not exist")
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
  
end
