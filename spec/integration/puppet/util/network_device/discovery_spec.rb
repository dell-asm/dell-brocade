#! /usr/bin/env ruby

require 'spec_helper'

require 'fixtures/unit/puppet/util/network_device/command_facts'
require 'spec_lib/puppet_spec/deviceconf'
include PuppetSpec::Deviceconf
include CommandFacts

describe "Integration Testing for Device Discovery Facts" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before(:all) do
	DevObj=	Puppet::Util::NetworkDevice::Brocade_fos::Device.new(device_conf['url'])
    @facts=DevObj.facts
  end

  let :create_zone do
    Puppet::Type.type(:brocade_zone).new(
    :zonename     => 'testZone28',
    :ensure   => 'present',
    :member => 'testMember',
    )
  end

  let :create_config_disable do
    Puppet::Type.type(:brocade_config).new(
    :configname    => 'DemoConfig',
    :configstate   => 'disable',
    :member_zone   => 'testZone28'
    )
  end
 

  describe "Device Discovery Behaviour" do

    context "when the different brocade commands are fired for the Discovery" do

      it "should have correct facts registered for 'version' command" do
        facts_exists_validate(VERSIONSHOW_HASH,@facts)
      end

      it "should have correct facts registered with right value for 'zoneshow' command" do

    	Facter.stub(:value).with(:url).and_return(device_conf['url'])
      	create_zone.provider.device_transport.connect
		create_zone.provider.create
		@facts["Zones"].should include("testZone28")
      end

     it "should have correct facts registered with right value for 'configshow' command" do

	    Facter.stub(:value).with(:url).and_return(device_conf['url'])
        create_config_disable.provider.device_transport.connect
        create_config_disable.provider.create
        @facts["Configs"].should include("DemoConfig")
     end

      it "should have correct facts registered for 'memshow' command" do
		facts_exists_validate(MEMSHOW_HASH,@facts)
      end

      it "should have correct facts registered for 'chassisshow' command" do
                facts_exists_validate(CHASSISSHOW_HASH,@facts)
      end

      it "should have correct facts registered for 'ipaddressshow' command" do
                facts_exists_validate(IPADDRESSSHOW_HASH,@facts)
      end

      it "should have correct facts registered for 'switchstatusshow' command" do
                facts_exists_validate(SWITCHSTATUSSHOW_HASH,@facts)
      end

  end
end
end
