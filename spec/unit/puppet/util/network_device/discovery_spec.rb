#! /usr/bin/env ruby

require 'spec_helper'

require 'yaml'
require 'fixtures/unit/puppet/util/network_device/facts_fixture'
require 'fixtures/unit/puppet/util/network_device/command_facts'
include CommandFacts

describe "Unit Testing for Device Discovery" do

  before(:each) do
    @fixture = Facts_fixture.new
    @transport = double('transport')
    @transport.stub(:command).with('chassisshow',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('switchshow -portcount',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('switchshow',{:cache=>true,:noop => false}).and_return @fixture.switchshow_resp
    @transport.stub(:command).with('ipaddrshow',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('switchstatusshow',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('memshow',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return ''
    @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return ''
  end

  describe "Device Discovery Facts Behaviour" do

    context "when the different brocade commands are fired for the Discovery" do

      it "should have correct facts registered with right value for 'switchshow' command" do
        @transport.stub(:command).with('switchshow',{:cache=>true,:noop => false}).and_return @fixture.switchshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(SWITCHSHOW_HASH,@facts)
      end

      it "should have correct facts registered with right value for 'chassisshow' command" do
        @transport.stub(:command).with('chassisshow',{:cache=>true,:noop => false}).and_return @fixture.chassisshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(CHASSISSHOW_HASH,@facts)

      end

      it "should have correct facts registered with right value for 'ipaddrshow' command" do
        @transport.stub(:command).with('ipaddrshow',{:cache=>true,:noop => false}).and_return @fixture.ipaddrshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(IPADDRESSSHOW_HASH,@facts)
      end

      it "should have correct facts registered with right value for 'switchstatusshow' command" do
        @transport.stub(:command).with('switchstatusshow',{:cache=>true,:noop => false}).and_return @fixture.switchstatusshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(SWITCHSTATUSSHOW_HASH,@facts)

      end

      it "should have correct facts registered with right value for 'memshow' command" do
        @transport.stub(:command).with('memshow',{:cache=>true,:noop => false}).and_return @fixture.memshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(MEMSHOW_HASH,@facts)
      end

      it "should have correct facts registered with right value for 'version' command" do

        @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return @fixture.version_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(VERSIONSHOW_HASH,@facts)

      end

      it "should have correct facts registered with right value for 'zoneshow' command" do

        @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return @fixture.zoneshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        validate_facts(ZONESHOW_HASH,@facts)
      end
    end
  end
end

