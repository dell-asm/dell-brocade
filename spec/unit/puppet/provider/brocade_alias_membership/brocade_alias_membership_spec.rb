#! /usr/bin/env ruby

require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_alias_membership/Brocade_alias_membership_fixture'

NOOP_HASH = { :noop => false}

describe Puppet::Type.type(:brocade_alias_membership).provider(:brocade_alias_membership) do

  before(:each) do
    @fixture = Brocade_alias_membership_fixture.new

    dummy_transport=double('transport')
    dummy_transport.stub(:command).and_return ""
    @fixture.provider.transport = dummy_transport
     @fixture.provider.stub(:cfg_save)

  end
  
  context "when brocade_alias_membership provider is created " do
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

  context "#create"
  it "should throw error if response is RESPONSE_NOT_FOUND" do

    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)

    expect {@fixture.provider.create}.to raise_error(Puppet::Error)

  end

  it "should throw error if response is RESPONSE_INVALID" do

    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)

    expect {@fixture.provider.create}.to raise_error(Puppet::Error)

  end

  it "should warn if brocade alias membership already exists" do

    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)

    Puppet.stub(:info)
    Puppet.should_receive(:info).once

    @fixture.provider.create

  end

  it "should save configuration  if brocade alias membership is created successfully" do

    @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_alias_membership_command, NOOP_HASH).and_return ("abc")
   
    @fixture.provider.should_receive(:cfg_save).once

    @fixture.provider.create
  end

end

