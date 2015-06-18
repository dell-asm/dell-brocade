require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_alias/brocade_alias_fixture'

NOOPS_HASH = {:noop => false}

describe Puppet::Type.type(:brocade_alias).provider(:brocade_alias) do

  before(:each) do
    @fixture = Brocade_alias_fixture.new
    mock_transport=double('transport')
    @fixture.provider.stub(:transport).and_return(mock_transport)
    @fixture.provider.stub(:cfg_save)
    Puppet.stub(:debug)

  end

  context "when brocade alias provider is created " do

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)
    end

    it "should have create method defined for brocade alias" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade alias" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade alias" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil

    end
  end

  context "when brocade alias is created" do
    it "should raise error if response contains 'invalid' while creating brocade alias" do
    #When-Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_CREATE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name],NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID_NAME)
      @fixture.provider.should_not_receive(:cfg_save)
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)

    end

    it "should raise error if response contains 'name too long' while creating brocade alias" do
    #When-Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_CREATE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name],NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)
      @fixture.provider.should_not_receive(:cfg_save)
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should warn if brocade alias name already exist" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_CREATE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name],NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME)
      @fixture.provider.should_not_receive(:cfg_save)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_ALREADY_EXIST_INFO%[@fixture.get_alias_name])

      #When
      @fixture.provider.create
    end

    it "should create the brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_CREATE_COMMAND%[@fixture.get_alias_name,@fixture.get_member_name],NOOPS_HASH).and_return("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.create
    end

  end

  context "when brocade alias is deleted" do
    it "should warn if response contains 'not found' while deleting the brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_DELETE_COMMAND%[@fixture.get_alias_name],NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@fixture.get_alias_name])

      #When
      @fixture.provider.destroy
    end

    it "should delete the already existing brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_DELETE_COMMAND%[@fixture.get_alias_name],NOOPS_HASH).and_return("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.destroy
    end
  end

  context "when brocade alias existence is validated" do
    it "should return true when the brocade alias exist" do
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name],NOOPS_HASH).and_return("abc")
      @fixture.provider.exists?.should == true

    end

    it "should return false when the brocade alias does not exist"do
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ALIAS_SHOW_COMMAND%[@fixture.get_alias_name],NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.exists?.should == false
    end

  end
end