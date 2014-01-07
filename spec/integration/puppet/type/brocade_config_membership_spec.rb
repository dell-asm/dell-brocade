require 'spec_helper'

describe Puppet::Type.type(:brocade_config_membership) do
  let(:title) { 'brocade_config_membership' }

  context 'should compile with given test params' do
    let(:params) { {
        :configname   => 'DemoConfig',
        :member_zone   => 'DemoMemberZone',
        :ensure   => 'present',

      }}
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    it "should have configname as one of its parameters for config name" do
      described_class.key_attributes.should == [:configname]
    end

    describe "when validating ensure property" do
      it "should support present" do
        described_class.new(:configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :ensure => 'absent')[:ensure].should == :absent
      end

    end
  end
end

