#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'fixtures/unit/puppet/provider/brocade_config/brocade_config_fixture'

NOOP_HASH = { :noop => false}
PROMPT_HASH = {:prompt => Puppet::Provider::Brocade_messages::CONFIG_ENABLE_PROMPT}

describe Puppet::Type.type(:brocade_config).provider(:brocade_config) do

  before(:each) do
    @fixture = Brocade_config_fixture.new
	  dummy_transport=double('transport')
    @fixture.provider.transport = dummy_transport
    @fixture.provider.stub(:cfg_save)
  end

  context "when brocade_config provider is created " do
    it "should have create method defined for brocade_config" do
      described_class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade_config" do
      described_class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_config" do
      described_class.instance_method(:exists?).should_not == nil
    end
	
	it "should have parent 'Puppet::Provider::Brocade_fos'" do
      described_class.new.should be_kind_of(Puppet::Provider::Brocade_fos)
    end
  end

  context "when brocade config is created and/or its state is changed" do
  it "should warn if brocade config name already exist and process the brocade config state" do
	#Then
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).and_return ("")
	resp = Puppet::Provider::Brocade_messages::CONFIG_ALREADY_EXIST%[@fixture.get_config_name]	
	Puppet.should_receive(:info).once.with(resp)
	@fixture.provider.should_receive(:process_config_state).once.and_return ("")
	
	#When
    @fixture.provider.create
  end
  
  it "should create brocade config if brocade config name is not present and process the brocade config state" do	
	#Then
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).and_return("")
	@fixture.provider.should_receive(:cfg_save).once
	@fixture.provider.should_receive(:process_config_state).once.and_return ("")
	
	#When
	@fixture.provider.create
  end
	
  it "should raise error if response contains 'invalid' while creating brocade config" do	
	#When - Then
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
	
    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end
	
   it "should raise error if response contains 'name too long' while creating brocade config" do
	#When - Then
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)

    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end
   
  it "should enable the brocade config state when brocade config state value is enabled in resource" do
	#Given
	Puppet.stub(:info)
	@fixture.set_configstate_enable
	
	#Then
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).and_return ("")
	@fixture.provider.should_receive(:process_config_state).once.and_call_original
	@fixture.provider.should_receive(:config_enable).once.and_call_original
	@fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_enable_command, PROMPT_HASH).and_return ("")
	@fixture.provider.transport.should_receive(:command).once.with("yes", NOOP_HASH).and_return ("")
	
	#When
	@fixture.provider.create
  end
	
   it "should raise error if response contains 'not found' while enabling the brocade config state"
   
   it "should disable the brocade config state when brocade config state value is disabled in resource"
   
   it "should warn if no effective brocade config found while disabling the brocade config state"
  
  end
   
   
   
   context "when brocade config is deleted" do
  	 it "should delete the already existing brocade config"
   
  	 it "should warn if brocade config name does not exist"
   
  	 it "should raise error if response contains 'should not be deleted'"
   
   end
   
   context "when brocade config existence is validated" do
   	it "should return false when the brocade config existence is required"
   
   	it "should return true when the brocade config existence is not required"
   
   end
    
end