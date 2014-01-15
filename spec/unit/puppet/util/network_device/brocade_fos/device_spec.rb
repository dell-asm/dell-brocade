require 'spec_helper'
require 'puppet/util/network_device/brocade_fos/device'

describe "Brocade Device" do

  before(:each) do
    @device_url = 'ssh://user:password@localhost:22'
    transport = double('transport')
    transport.stub(:is_a?).and_return 'true'
    transport.stub(:command).and_return ''
    @fixture =Puppet::Util::NetworkDevice::Brocade_fos::Device.new(@device_url)
    @fixture.transport = transport
    @fixture.stub(:super).and_return("")
  end

  context 'when creating the device' do

    context "when brocade device is created " do

      it "should have parent 'Puppet::Provider::Brocade_fos'" do
        @fixture.should be_kind_of(Puppet::Util::NetworkDevice::Base_fos)
      end

      it "should have connect transport method defined for brocade device" do
        @fixture.class.instance_method(:connect_transport).should_not == nil
      end

      it "should have login method defined for brocade device" do
        @fixture.class.instance_method(:login).should_not == nil
      end

      it "should have init method defined for brocade device" do
        @fixture.class.instance_method(:init).should_not == nil
      end

      it "should have init facts method defined for brocade device" do
        @fixture.class.instance_method(:init_facts).should_not == nil
      end

      it "should have facts method defined for brocade device" do
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

    context "should be able to connect and login the device" do

      it " allows connection on the device and login " do
        @fixture.transport.should_receive(:connect).once
        @fixture.should_receive(:login).once
        @fixture.connect_transport
      end

    end

    context "should be able to validate and login" do

      it " should prompt for the password, when username is given " do
        @fixture.transport.should_receive(:handles_login?).once.and_return(false)
        @fixture.transport.should_receive(:command).once.with(@fixture.url.user, {:prompt => /^Password:/, :noop => false})
        @fixture.transport.should_receive(:command).once.with(@fixture.url.password, :noop => false)
        @fixture.login
      end

      it "should give Password regex, when username is not given " do
        @fixture.transport.should_receive(:handles_login?).once.and_return(false)
        @fixture.url.stub(:user).and_return ''
        @fixture.transport.should_not_receive(:command).with(@fixture.url.user, {:prompt => /^Password:/, :noop => false})
        @fixture.transport.should_receive(:expect).with(/^Password:/).once
        @fixture.transport.should_receive(:command).once.with(@fixture.url.password, :noop => false)

        @fixture.login
      end

      it "should not perform any processing, when transport handles the login " do
        @fixture.transport.should_receive(:handles_login?).once.and_return(true)
        @fixture.transport.should_not_receive(:command).with(@fixture.url.user, {:prompt => /^Password:/, :noop => false})
        @fixture.transport.should_not_receive(:command).with(@fixture.url.password, :noop => false)
        @fixture.login
      end

    end

    context "should initialize connection and facts retreive " do

      it "should call connect transport method once" do
        @fixture.should_receive(:connect_transport).once.ordered
        @fixture.should_receive(:init_facts).once.ordered
        @fixture.init

      end

    end

    context "should initialize facts_to_hash method " do

      it "should initiate the facts_to_hash method once" do
        @mock_facts = Puppet::Util::NetworkDevice::Brocade_fos::Facts.new(@fixture.transport)
        @fixture.set_facts(@mock_facts)
        @fixture.should_receive(:init).once.ordered
        @fixture.get_facts.should_receive(:facts_to_hash).once
        @fixture.facts
      end

    end

  end
end