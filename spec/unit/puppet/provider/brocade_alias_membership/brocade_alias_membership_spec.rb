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

  context "when brocade alias membership is created"

  it "should raise error if response contains 'not found' while creating brocade alias membership" do
  #Then
    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
    #When
    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end

  it "should raise error if response contains 'invalid' while creating brocade alias membership" do
  #Then
    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
    #When
    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end

  it "should warn if brocade alias membership already exists" do
  #Then
    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)

    resp = Puppet::Provider::Brocade_messages::ALIAS_MEMBERSHIP_ALREADY_EXIST_INFO%[@fixture.brocade_alias_membership[:member],@fixture.brocade_alias_membership[:alias_name]]
    Puppet.stub(:info)
    Puppet.should_receive(:info).once.with(resp)

    #When
    @fixture.provider.create

  end

  it "should save the configuration, if brocade alias membership is created successfully" do
  #Then
    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return ("abc")
    @fixture.provider.should_receive(:cfg_save).once
    #When
    @fixture.provider.create
  end

end

