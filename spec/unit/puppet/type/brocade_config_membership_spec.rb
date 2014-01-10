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
    it "should have name as a key parameters for config name" do
      described_class.key_attributes.should == [:name]
    end

    context "when validating attributes" do
      [:configname, :member_zone].each do |param|
        it "should have a #{param} parameter" do
          described_class.attrtype(param).should == :param
        end
      end
    end

    describe "when validating ensure property" do
      it "should support present" do
        described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'absent')[:ensure].should == :absent
      end

    end
  end
end

