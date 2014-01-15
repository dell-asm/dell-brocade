#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
include PuppetSpec::Fixtures
#require 'puppet\util\network_device\facts'
require 'fixtures/unit/puppet/util/network_device/facts_fixture'

describe Puppet::Util::NetworkDevice::Brocade_fos::Facts do
  
before(:each) do
  @fixture = Facts_fixture.new
end

  # let :version do
    # YAML.load_file(my_fixture('version1.yml'))
  # end


  describe "Device Discovery Behaviour" do
    context "when the defferent brocade commands are fired for the Discovery" do
      it "should have correct facts registered for 'version' command" do
        @transport ='transport'
        @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return @fixture.version_resp
        #resp = YAML.load_file(my_fixture('version1.yml'))
        #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return resp['version'] 
        @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return ''
        #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return version
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "version: #{@facts.retrieve} "
        #@facts.retrieve["Fabric Os"].should == "v7.2.0a"
      #@facts.retrieve.should == {"Fabric Os"=>"v7.2.0a"}
      end
      it "should have correct facts registered for 'zone' command" do
        @transport ='transport'
        @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return ''
        @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return @fixture.zoneshow_resp
        @facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        puts "zone_config: #{@facts.retrieve} "
        @facts.retrieve["Zone_Config_3"].should include("yahoo")
      end

    end

    context " when the Facts are register for respective command" do
      it "should have correct list of Facts " do
      end
    end
  end

end

