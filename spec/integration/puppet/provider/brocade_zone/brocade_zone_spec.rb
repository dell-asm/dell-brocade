#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'

describe "Integration test for brocade zone create and destroy" do

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

  def get_zoneshow_cmd(zonename)
    command = "zoneshow #{zonename}"
  end

  context "should Create and Destroy Zone" do
    it "should create a brocade zone" do
      destroy_zone.provider.device_transport.connect
      ##Initially check the presense of the zone,if exist destroy the existing zone
      ##and continue the create zone feature of the brocade_zone provider.
      zone_show_res = destroy_zone.provider.device_transport.command(get_zoneshow_cmd(create_zone[:zonename]),:noop=>false)
      if presense?(zone_show_res,"does not exist") == false
        ##if zone already exist, will delete the zone and continue with the test.
        zone_del_res = destroy_zone.provider.device_transport.command("zonedelete #{create_zone[:zonename]}",:noop=>false)
        cfg_save_res = destroy_zone.provider.device_transport.command("cfgsave", :prompt => /Do/)
        if cfg_save_res.match(/fail|err|not found|not an alias/)
          puts "Unable to save the Config because of the following issue: #{cfg_save_res}"
        else
          puts "Successfully saved the Config"
        end
      end
      destroy_zone.provider.device_transport.close
      create_zone.provider.device_transport.connect
      create_zone.provider.create
      create_response = create_zone.provider.device_transport.command(get_zoneshow_cmd(create_zone[:zonename]),:noop=>false)
      create_response.should_not include("does not exist")
      create_zone.provider.device_transport.close
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
