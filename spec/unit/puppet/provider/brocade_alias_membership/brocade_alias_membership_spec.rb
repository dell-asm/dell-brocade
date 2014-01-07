#! /usr/bin/env ruby

require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_alias_membership/Brocade_alias_membership_fixture'

NOOP_HASH = { :noop => false}

describe Puppet::Type.type(:brocade_alias_membership).provider(:brocade_alias_membership) do

#Given
  before(:each) do
    @fixture = Brocade_alias_membership_fixture.new
    dummy_transport=double('transport')
    dummy_transport.stub(:command).and_return ""
    @fixture.provider.transport = dummy_transport
    @fixture.provider.stub(:cfg_save)
    createDebugMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_DEBUG%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
  end

  context "when brocade_alias_membership provider is created " do

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      described_class.new.should be_kind_of(Puppet::Provider::Brocade_fos)

    end

    it "should have create method defined for brocade_alias_membership" do
      described_class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade_alias_membership" do
      described_class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_alias_membership" do
      described_class.instance_method(:exists?).should_not == nil
    end

  end

  context "when brocade alias membership is created" do

    before(:each) do
      @createDebugMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_CREATE_DEBUG%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
      @createInfoMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
    end

    it "should raise error if response contains 'not found' while creating brocade alias membership" do
    #Then

      Puppet.should_receive(:debug).once.with(@createDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)

    end

    it "should raise error if response contains 'invalid' while creating brocade alias membership" do
    #Then
      Puppet.should_receive(:debug).once.with(@createDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should warn if brocade alias membership already exists" do
    #Then
      Puppet.should_receive(:debug).once.with(@createDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)

      Puppet.should_receive(:info).once.with(@createInfoMsg).and_return("")

      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.create

    end

    it "should save the configuration, if brocade alias membership is created successfully" do
    #Then
      Puppet.should_receive(:debug).once.with(@createDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return ("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.create
    end

  end

  context "when brocade alias membership is deleted" do

    before(:each) do
      @destroyDebugMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_DESTROY_DEBUG%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
      @destroyInfoMsg = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
    end
    it "should save the configuration, if brocade alias membership is deleted successfully" do
    #Then
      Puppet.should_receive(:debug).once.with(@destroyDebugMsg).and_return("")
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_destroy_brocade_alias_membership_command, NOOP_HASH).and_return ("")
      @fixture.provider.should_receive(:cfg_save).once
      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade alias name does not exist" do
    #Then
      Puppet.should_receive(:debug).once.with(@destroyDebugMsg).and_return("")
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_destroy_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_IS_NOT_IN)

      resp = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_REMOVED_INFO%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]

      Puppet.should_receive(:info).once.with(resp).and_return("")

      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.destroy
    end

    it "should raise error if response contains 'does not exist' while deleting the brocade alias membership" do
       #Then
      Puppet.should_receive(:debug).once.with(@destroyDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_destroy_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

    it "should raise error if response contains 'not found' while deleting the brocade alias membership" do
             #Then
      Puppet.should_receive(:debug).once.with(@destroyDebugMsg).and_return("")

      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_destroy_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

  end

  context "when brocade alias membership existance is validated" do

    it "should return true, if ensure property has value present"

    it "should return false, if ensure property has value absent"

  end

end

