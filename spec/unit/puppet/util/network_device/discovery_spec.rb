#! /usr/bin/env ruby

require 'spec_helper'

require 'yaml'
require 'fixtures/unit/puppet/util/network_device/facts_fixture'
require 'fixtures/unit/puppet/util/network_device/commandresponse_hash'

include  CommandResponse_Hash

describe Puppet::Util::NetworkDevice::Brocade_fos::Facts do

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

  describe "Device Discovery Behaviour" do

    context "when the defferent brocade commands are fired for the Discovery" do

      it "should have correct facts registered with right value for 'switchshow' command" do
        @transport.stub(:command).with('switchshow',{:cache=>true,:noop => false}).and_return @fixture.switchshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "switch_config: #{@facts.retrieve} "
        Validate_Facts(SWITCHSHOW_HASH,@facts)

      end

      it "should have correct facts registered with right value for 'chassisshow' command" do
        @transport.stub(:command).with('chassisshow',{:cache=>true,:noop => false}).and_return @fixture.chassisshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "chassis_config: #{@facts.retrieve} "
        Validate_Facts(CHASSISSHOW_HASH,@facts)

      end

      it "should have correct facts registered with right value for 'ipaddrshow' command" do
        @transport.stub(:command).with('ipaddrshow',{:cache=>true,:noop => false}).and_return @fixture.ipaddrshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "ipaddr_config: #{@facts.retrieve} "
        Validate_Facts(IPADDRESSSHOW_HASH,@facts)
      end

      it "should have correct facts registered with right value for 'switchstatusshow' command" do
        @transport.stub(:command).with('switchstatusshow',{:cache=>true,:noop => false}).and_return @fixture.switchstatusshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        Validate_Facts(SWITCHSTATUSSHOW_HASH,@facts)
        puts "hash for switchshow : #{@facts.retrieve}"

      end

      it "should have correct facts registered with right value for 'memshow' command" do
        @transport.stub(:command).with('memshow',{:cache=>true,:noop => false}).and_return @fixture.memshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        Validate_Facts(MEMSHOW_HASH,@facts)
        puts "hash for memshow  : #{@facts.retrieve}"
      end

      it "should have correct facts registered with right value for 'version' command" do

        @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return @fixture.version_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        Validate_Facts(VERSIONSHOW_HASH,@facts)
        puts "hash: #{@facts.retrieve}"

      end

      it "should have correct facts registered for 'zoneshow' command" do
        @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return @fixture.zoneshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "zone_config: #{@facts.retrieve} "
        Validate_Facts(ZONESHOW_HASH,@facts)
      end
    end
  end
end
