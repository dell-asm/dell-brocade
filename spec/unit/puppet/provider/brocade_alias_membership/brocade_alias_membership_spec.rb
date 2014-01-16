require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_alias_membership/brocade_alias_membership_fixture'

describe "Brocade Alias Membership Provider" do

#Given
  before(:each) do
    @fixture = Brocade_alias_membership_fixture.new
    mock_transport=double('transport')
    @fixture.provider.transport = mock_transport
    Puppet.stub(:info)
    Puppet.stub(:debug)
  end

  context "when brocade alias membership provider is created " do

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)

    end

    it "should have create method defined for brocade alias membership" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade alias membership" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_alias_membership" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

  end

  context "when brocade alias membership is created" do

    before(:each) do
      @createInfoMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@fixture.get_member_name,@fixture.get_alias_name]
    end

    it "should raise error if response contains 'not found' while creating brocade alias membership" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name],NOOP_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)

    end

    it "should raise error if response contains 'invalid' while creating brocade alias membership" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should warn if brocade alias membership already exists" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)
      Puppet.should_receive(:info).once.ordered.with(@createInfoMsg).and_return("")
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.create

    end

    it "should save the configuration, if brocade alias membership is created successfully" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_ADD_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.create
    end

  end

  context "when brocade alias membership is deleted" do

    before(:each) do
      @destroyInfoMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.get_member_name,@fixture.get_alias_name]
    end

    it "should save the configuration, if brocade alias membership is deleted successfully" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return("")
      @fixture.provider.should_receive(:cfg_save).once.ordered

      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade alias name does not exist" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN)
      Puppet.should_receive(:info).once.ordered.with(@destroyInfoMsg).and_return("")
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.destroy
    end

    it "should raise error if response contains 'does not exist' while deleting the brocade alias membership" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

    it "should raise error if response contains 'is not in' while deleting the brocade alias membership" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_MEMBER_REMOVE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name], NOOP_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN)
      Puppet.should_receive(:info).once.ordered.with(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.get_member_name,@fixture.get_alias_name])
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.destroy
    end

  end

  context "when brocade alias membership existence is validated" do

    it "should warn if brocade alias name does not exist and when ensure property is given present" do
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@fixture.get_alias_name])
      @fixture.provider.exists?.should == true
    end

    it "should warn if brocade alias name does not exist and when ensure property is given absent" do
      @fixture.set_ensure_value_absent
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@fixture.get_alias_name])
      @fixture.provider.exists?.should == false
    end

    it "should return false if brocade alias name exist and wwpn is not associated to it when ensure property is given present" do
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return("")
      @fixture.provider.exists?.should == false
    end

    it "should return true if brocade alias name exist and wwpn is associated to it when ensure property is given present" do
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return(@fixture.get_member_name)
      @fixture.provider.exists?.should == true
    end

    it "should warn if brocade alias name exist and wwpn is associated to it when ensure property is given present" do
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return(@fixture.get_member_name)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@fixture.get_member_name,@fixture.get_alias_name])
      @fixture.provider.exists?.should == true
    end

    it "should return true if brocade alias name exist and wwpn is associated to it when ensure property is given absent" do
      @fixture.set_ensure_value_absent
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return(@fixture.get_member_name)
      @fixture.provider.exists?.should == true
    end

    it "should return false if brocade alias name exist and wwpn is not associated to it when ensure property is given absent" do
      @fixture.set_ensure_value_absent
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return("")
      @fixture.provider.exists?.should == false
    end

    it "should warn if brocade alias name exist and wwpn is not associated to it when ensure property is given absent" do
      @fixture.set_ensure_value_absent
      @fixture.provider.should_receive(:device_transport).once.ordered
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name], NOOP_HASH).ordered.and_return("")
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.get_member_name,@fixture.get_alias_name])
      @fixture.provider.exists?.should == false
    end

  end

end

