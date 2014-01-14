require 'spec_helper'
require 'puppet/util/network_device/brocade_fos/device'

describe "Brocade Device" do
  before(:each) do
    @device_url = 'ssh://user:password@localhost:22'
    transport = double('transport')
    transport.stub(:is_a?).and_return 'true'
    transport.stub(:command).and_return ''

    @fixture = Puppet::Util::NetworkDevice::Brocade_fos::Device.new(@device_url)
    @fixture.transport = transport
    @fixture.stub(:super).and_return("")
  #   @fixture.stub(:initialize).and_return("")
  end

  context 'when creating the device' do

    context "when brocade Zone Membership provider is created " do

      it "should have parent 'Puppet::Provider::Brocade_fos'" do
        @fixture.should be_kind_of(Puppet::Util::NetworkDevice::Base_fos)
      end

      it "should have create method defined for brocade Zone Membership" do
        @fixture.class.instance_method(:connect_transport).should_not == nil
      end

      it "should have destroy method defined for brocade Zone Membership" do
        @fixture.class.instance_method(:login).should_not == nil
      end

      it "should have exists? method defined for brocade_zone_membership" do
        @fixture.class.instance_method(:init).should_not == nil
      end

      it "should have exists? method defined for brocade_zone_membership" do
        @fixture.class.instance_method(:init_facts).should_not == nil
      end

      it "should have exists? method defined for brocade_zone_membership" do
        @fixture.class.instance_method(:facts).should_not == nil
      end

    end

    context "should initialize all states of the obects (parent & child class)" do

      it "initialize method should be called." do
        Puppet::Util::NetworkDevice::Brocade_fos::Device.any_instance.should_receive(:initialize)
        Puppet::Util::NetworkDevice::Brocade_fos::Device.new(@device_url)
      end

      it "should initialize device URL correctly" do
        @fixture.url.should == URI.parse(@device_url)

      end

    end
  end
end