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
    it "should raise error if response contains 'name too long' while creating brocade alias" 
	
	it "should raise error if response contains 'invalid' while creating brocade alias" 
	
	it "should warn if brocade alias name already exist" 
	
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
  
end

