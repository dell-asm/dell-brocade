#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
include PuppetSpec::Fixtures
#require 'puppet\util\network_device\facts'
require 'fixtures/unit/puppet/util/network_device/facts_fixture'

describe Puppet::Util::NetworkDevice::Brocade_fos::Facts do

before(:each) do
  @fixture = Facts_fixture.new
  @transport = double('transport')
  @transport.stub(:command).with('switchshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('chasisshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('ipaddrshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('switchstatusshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('memshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return ''
  @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return ''
end

  # let :version do
    # YAML.load_file(my_fixture('version1.yml'))
  # end


  describe "Device Discovery Behaviour" do

    context "when the defferent brocade commands are fired for the Discovery" do

      it "should have correct facts registered with right value for 'switchshow' command"

      it "should have correct facts registered with right value for 'chasisshow' command"

      it "should have correct facts registered with right value for 'ipaddrshow' command"

      it "should have correct facts registered with right value for 'switchstatusshow' command"

      it "should have correct facts registered with right value for 'memshow' command"

      it "should have correct facts registered with right value for 'zoneshow' command"



      it "should have correct facts registered with right value for 'version' command" do
       # @transport ='transport'
       # @transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return @fixture.version_resp
        #resp = YAML.load_file(my_fixture('version1.yml'))
        #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return resp['version']
        #@transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return ''
        #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return version
        #@facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
       # puts "version: #{@facts.retrieve} "
        #@facts.retrieve["Fabric Os"].should == "v7.2.0a"
      #@facts.retrieve.should == {"Fabric Os"=>"v7.2.0a"}

       #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return ''
       #@facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
       #@facts.retrieve["Fabric Os"].should == "v7.2.0a"

      end

      it "should have correct facts registered for 'zoneshow' command" do
       # @transport ='transport'

        #@transport.stub(:command).with('version',{:cache=>true,:noop => false}).and_return ''
        #@transport.stub(:command).with('zoneshow',{:cache=>true,:noop => false}).and_return @fixture.zoneshow_resp
        #@facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@transport)
        #puts "zone_config: #{@facts.retrieve} "
        #@facts.retrieve["Zone_Config_3"].should include("yahoo")
      end



    end

 end

end
