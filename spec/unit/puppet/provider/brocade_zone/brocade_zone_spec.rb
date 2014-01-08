#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'fixtures/unit/puppet/provider/brocade_zone/brocade_zone_fixture'

NOOP_HASH = { :noop => false}

describe "testing the brocade zone" do

  before(:each) do
    @fixture = Brocade_zone_fixture.new
    
    #puts "fixture OBj: #{@fixture}"
    
    dummy_transport=double('transport')
    #puts "transport OBj: #{dummy_transport}"
    @fixture.provider.transport = dummy_transport
    
    @fixture.provider.stub(:cfg_save)
  end

  context "when brocade_zone provider is created " do
    it "should have create method defined for brocade_config" do
       @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have destroy method defined for brocade_config" do
       @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_config" do
       @fixture.provider.class.instance_method(:exists?).should_not == nil
    end
  
  it "should have parent 'Puppet::Provider::Brocade_fos'" do
       @fixture.provider.class.new.should be_kind_of(Puppet::Provider::Brocade_fos)
    end
  end

  context "when brocade zone is created " do
  it "should warn if brocade zone name already exist and process the brocade config state" do
  #Then
  @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_zone_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)
  #@fixture.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_zone_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)
  resp = Puppet::Provider::Brocade_messages::ZONE_ALREADY_EXIST_INFO%[@fixture.get_zone_name] 
  Puppet.should_receive(:info).once.with(resp)
    
  #When
    @fixture.provider.create
  end
 end
  
  it "should create brocade zone if brocade zone name is not present" do  
  #Then
  @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_zone_command, NOOP_HASH).and_return ""
  @fixture.provider.should_receive(:cfg_save).once
    
  #When
  @fixture.provider.create
  end
  
  it "should raise error if response contains 'invalid' while creating brocade zone" do 
  #When - Then
  @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_zone_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
  expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end
  
   it "should raise error if response contains 'name too long' while creating brocade zone" do
  #When - Then
  
  @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_create_brocade_zone_command, NOOP_HASH).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)

    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end
   
 
   context "when brocade config is deleted" do
    it "should delete the already existing brocade config" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_delete_brocade_zone_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:cfg_save).once
      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade config name does not exist" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_delete_brocade_zone_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      resp = Puppet::Provider::Brocade_messages::ZONE_ALREADY_REMOVED_INFO%[@fixture.get_zone_name]
      Puppet.should_receive(:info).once.with(resp)
      @fixture.provider.should_not_receive(:cfg_save)
      #When
      @fixture.provider.destroy
    end

  end 
  
       
end

