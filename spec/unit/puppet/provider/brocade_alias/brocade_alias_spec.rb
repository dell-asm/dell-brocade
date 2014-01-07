#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

describe Puppet::Type.type(:brocade_alias).provider(:brocade_alias) do

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
	 #Given
	  fixture = Brocade_alias_fixture.new
	  ops_hash = {:noop => false}
	  dummy_transport=double('transport')
	  fixture.provider.transport = dummy_transport 
	 
	 #When-Then
      dummy_transport.should_receive(:command).once.with(fixture.provider.get_create_alias_command,ops_hash).and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID_NAME)
	  expect {fixture.provider.create}.to raise_error(Puppet::Error)
	end
	
	it "should raise error if response contains 'name too long' while creating brocade alias" do
	 #Given
      fixture = Brocade_alias_fixture.new
	  ops_hash = {:noop => false}
	  dummy_transport=double('transport')
	  fixture.provider.transport = dummy_transport 
	  
	  #When-Then
      dummy_transport.should_receive(:command).once.with(fixture.provider.get_create_alias_command,ops_hash).and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)
	  expect {fixture.provider.create}.to raise_error(Puppet::Error)	
	end
	
	it "should warn if brocade alias name already exist" do
	  fixture = Brocade_alias_fixture.new
	  ops_hash = {:noop => false}
	  dummy_transport=double('transport')
	  fixture.provider.transport = dummy_transport 
	  
      #When-Then
      dummy_transport.should_receive(:command).once.with(fixture.provider.get_create_alias_command,ops_hash).and_return(Puppet::Provider::Brocade_responses::RESPONSE_DUPLICATE_NAME)
      Puppet.stub(:info)
	  Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::ALIAS_ALREADY_EXIST_INFO%[fixture.get_alias_name])
	  
	  #When
	  fixture.provider.create
	  
	  end
	it "should create the brocade alias" 
	
  end
  
  context "when brocade alias is deleted" do
   	it "should warn if response contains 'not found' while deleting the brocade alias" 
	
	it "should delete the brocade alias"	
  end
  
  context "when brocade alias existence is validated" do
   	it "should return true when the brocade alias exist" 
	
	it "should return false when the brocade alias does not exist" 	
  end
  
  class Brocade_alias_fixture

  attr_accessor :brocade_alias, :provider

  def initialize
    @brocade_alias = get_brocade_alias
	@provider = brocade_alias.provider	
  end
  
  private 
  def  get_brocade_alias
    Puppet::Type.type(:brocade_alias).new(
    :alias_name => 'DemoAlias',
    :ensure => 'present',
    :member => '0f:0a:0a:0a:0a:0a:0a:0a'
	)
  end
  
  public
  def get_alias_name
    brocade_alias[:alias_name]
  end
  end
  
end

