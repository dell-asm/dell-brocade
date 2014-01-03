#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'

describe Puppet::Type.type(:brocade_zone).provider(:brocade_zone) do
  

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
end

