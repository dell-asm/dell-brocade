require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_config_membership/Brocade_config_membership_fixture'

NOOP_HASH = { :noop => false}

describe "Brocade Config Membership Provider" do

#Given
  before(:each) do
    @fixture = Brocade_config_membership_fixture.new
    mock_transport=double('transport')
    @fixture.provider.transport = mock_transport
    Puppet.stub(:info)
    Puppet.stub(:debug)
  end

  context "when brocade config membership provider is created " do

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)

    end

    it "should have create method defined for brocade config membership" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade config membership" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade config membership" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

  end

  context "when brocade config membership is created" do

    before(:each) do
      @createInfoMsg = Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO%[@fixture.brocade_config_membership[:member_zone],@fixture.brocade_config_membership[:configname]]
    end

    it "should raise error if response contains 'not found' while creating brocade config membership" do
    #Then
      @fixture.provider.should_receive(:config_add_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_add_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)

    end

    it "should raise error if response contains 'invalid' while creating brocade config membership" do
    #Then
      @fixture.provider.should_receive(:config_add_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_add_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should warn if brocade config membership already exists" do
    #Then
      @fixture.provider.should_receive(:config_add_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_add_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)
      Puppet.should_receive(:info).once.with(@createInfoMsg).ordered.and_return("")
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.create

    end

    it "should save the configuration, if brocade config membership is created successfully" do
    #Then
      @fixture.provider.should_receive(:config_add_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_add_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:cfg_save).once.ordered

      #When
      @fixture.provider.create
    end

  end

  context "when brocade config membership is deleted" do

    before(:each) do
      @destroyInfoMsg = Puppet::Provider::Brocade_messages::CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.brocade_config_membership[:member_zone],@fixture.brocade_config_membership[:configname]]
    end

    it "should save the configuration, if brocade config membership is deleted successfully" do
    #Then
      @fixture.provider.should_receive(:config_remove_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_remove_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:cfg_save).once.ordered

      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade config membership does not exist" do
    #Then
      @fixture.provider.should_receive(:config_remove_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_remove_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN)
      Puppet.should_receive(:info).once.with(@destroyInfoMsg).ordered.and_return("")
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.destroy
    end

    it "should raise error if response contains 'invalid' while deleting the brocade config membership" do
    #Then
      @fixture.provider.should_receive(:config_remove_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_remove_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

    it "should raise error if response contains 'too long' while deleting the brocade config membership" do
    #Then
      @fixture.provider.should_receive(:config_remove_zone).once.ordered.and_call_original

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_config_remove_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

  end

  context "when brocade config membership existence is validated" do

    it "should return true when the brocade config membership exist" do

      @fixture.provider.should_receive(:device_transport).once.ordered

      @fixture.provider.exists?.should == false

    end

    it "should return false when the brocade config membership does not exist" do
      @fixture = Brocade_config_membership_fixture_with_absent.new

      @fixture.provider.should_receive(:device_transport).once.ordered

      @fixture.provider.exists?.should == true

    end

  end

end

