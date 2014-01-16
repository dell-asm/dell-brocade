require 'spec_helper'

describe Puppet::Type.type(:brocade_config_membership) do
  let(:title) { 'brocade_config_membership' }

  context 'should compile with given test params' do
    let(:params) { {
        :name   => 'DemoConfig:DemoMemberZone',
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
      [:ensure].each do |prop|
        it "should have a #{prop} property" do
          described_class.attrtype(prop).should == :property
        end
      end
    end

    context "when validating values" do
      describe "validating name param" do
        it "should be a tuple of two values" do
          described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'present')[:name].should == 'DemoConfig:DemoMemberZone'
        end

        it "should have config name value before first splitter(:)" do
          described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'present')[:configname].should == 'DemoConfig'
        end

        it "should have zone member value(s) after first splitter(:)" do
          described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'present')[:member_zone].should == 'DemoMemberZone'
        end

      end

      describe "validating configname variable" do

        it "should support an alphanumerical name" do
          described_class.new(:name => 'DemoConfig56:DemoMemberZone', :ensure => 'present')[:configname].should == 'DemoConfig56'
        end

        it "should support underscores" do
          described_class.new(:name => 'Demo_Config:DemoMemberZone', :ensure => 'present')[:configname].should == 'Demo_Config'
        end

        it "should not support blank value" do
          expect {described_class.new(:name => ':memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end

        it "should not support special characters" do
          expect { described_class.new(:name => 'demo@#$%config:memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
      end

      describe "validating zone member variable" do

        it "should support semicolon separated list of config_name and member_zone" do
          described_class.new(:name => 'Demo_Config:DemoMemberZone', :ensure => 'present')[:member_zone].should == 'DemoMemberZone'
        end

        it "should not support empty zone member list" do
          expect {described_class.new(:name => 'DemoConfig:', :ensure => 'present')}.to raise_error Puppet::Error
        end

        it "should not support special characters for zone member list" do
          expect { described_class.new(:name => 'DemoConfig:member@#$%^zone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end

      end

      describe "when validating ensure property" do
        it "should support present" do
          described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'present')[:ensure].should == :present
        end

        it "should support absent" do
          described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'absent')[:ensure].should == :absent
        end

        it "should not allow values other than present or absent" do
          expect { described_class.new(:name => 'DemoConfig:DemoMemberZone', :ensure => 'invalid')}.to raise_error Puppet::Error
        end

      end
    end
  end

end