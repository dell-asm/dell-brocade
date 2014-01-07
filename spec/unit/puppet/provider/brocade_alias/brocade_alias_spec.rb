#! /usr/bin/env ruby
require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_alias/Brocade_alias_fixture'

NOOPS_HASH = {:noop => false}

describe Puppet::Type.type(:brocade_alias).provider(:brocade_alias) do

  before(:each) do
    @fixture = Brocade_alias_fixture.new
    dummy_transport=double('transport')
    dummy_transport.stub(:command)
    @fixture.provider.transport = dummy_transport
    @fixture.provider.stub(:cfg_save)

  end

  context "when brocade_zone provider is created " do
    it "should have create method defined for brocade_zone" do
      described_class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade_zone" do
      described_class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_zone" do
      described_class.instance_method(:exists?).should_not == nil

    end
  end

  context "when brocade alias is created" do
    it "should raise error if response contains 'invalid' while creating brocade alias" do
    #When-Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_alias_command,NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID_NAME)
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should raise error if response contains 'name too long' while creating brocade alias" do
    #When-Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_alias_command,NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should warn if brocade alias name already exist" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_alias_command,NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_ALREADY_EXIST_INFO%[@fixture.get_alias_name])

      #When
      @fixture.provider.create
    end

    it "should create the brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_alias_command,NOOPS_HASH).and_return ("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.create
    end

  end

  context "when brocade alias is deleted" do
    it "should warn if response contains 'not found' while deleting the brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_delete_alias_command,NOOPS_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_DOES_NOT_EXIST_INFO%[@fixture.get_alias_name])

      #When
      @fixture.provider.destroy
    end

    it "should delete the brocade alias" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_delete_alias_command,NOOPS_HASH).and_return ("")
      @fixture.provider.should_receive(:cfg_save).once

      #When
      @fixture.provider.destroy
    end
  end

  context "when brocade alias existence is validated" do
    it "should return true when the brocade alias exist" do

      @fixture.provider.should_receive(:device_transport).once
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_alias_show_command,NOOPS_HASH).and_return ("abc")

      @fixture.provider.exists?.should == true

    end

    it "should return false when the brocade alias does not exist"do

      @fixture.provider.should_receive(:device_transport).once
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_alias_show_command,NOOPS_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.exists?.should == false
    end

  end
end

