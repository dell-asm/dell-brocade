require 'spec_helper'

describe Puppet::Type.type(:brocade_config) do
  let(:title) { 'brocade_config' }

  context 'should compile with given test params' do
    let(:params) { {
        :name         => 'zonename:DemoConfig',
        :configname   => 'DemoConfig',
        :member_zone   => 'DemoMemberZone',
        :configstate   => 'enable',
    }}
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    it "should have configname as one of its parameters for config name" do
      described_class.key_attributes.should == [:name]
    end

    describe "when validating attributes type" do
      [:configname, :member_zone].each do |param|
        it "should have a #{param} parameter" do
          described_class.attrtype(param).should == :param
        end
      end

      [:ensure, :configstate].each do |prop|
        it "should have a #{prop} property" do
          described_class.attrtype(prop).should == :property
        end
      end
    end
  end

  context "when validating values" do

    describe "validating configname variable" do

      it "should support an alphanumerical name" do
        described_class.new(:name => 'zonename:DemoConfig1', :configname   => 'DemoConfig1', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')[:configname].should == 'DemoConfig1'
      end

      it "should support underscores" do
        described_class.new(:name => 'zonename:DemoConfig1', :configname   => 'DemoConfig_1', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')[:configname].should == 'DemoConfig_1'
      end

      it "should not support blank value" do
        expect { described_class.new(:name => 'zonename:DemoConfig1', :configname   => '', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support special characters" do
        expect { described_class.new(:name => 'zonename:DemoConfig1', :configname   => 'DemoCon@#fig_1', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support numeric value at the start of the string" do
        expect { described_class.new(:name => 'zonename:DemoConfig1', :configname   => '1DemoConfig1', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support  long name (64 characters maximum limit)" do
        expect { described_class.new(:name => 'zonename:DemoConfig1', :configname   => 'abcdefghijknlmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz123456789012', :member_zone   => 'DemoMemberZone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end


    end

    describe "validating member_zone variable" do

      it "should support an alphanumerical name" do
        described_class.new(:name => 'zonename:DemoConfig',:configname   => 'DemoConfig', :member_zone   => 'DemoMemberZone1', :configstate   => 'enable', :ensure => 'present')[:member_zone].should == 'DemoMemberZone1'
      end

      it "should support underscores" do
        described_class.new(:name => 'zonename:DemoConfig', :configname   => 'DemoConfig', :member_zone   => 'DemoMemberZone_1', :configstate   => 'enable', :ensure => 'present')[:member_zone].should == 'DemoMemberZone_1'
      end

      it "should not support blank value" do
        expect { described_class.new(:name => 'zonename:DemoConfig', :configname   => 'DemoConfig', :member_zone   => '', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support special characters" do
        expect { described_class.new(:name => 'zonename:DemoConfig', :configname   => 'DemoConfig', :member_zone   => 'DemoMember@#Zone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support numeric character at the beginning of the zone name" do
        expect { described_class.new(:name => 'zonename:DemoConfig', :configname   => 'DemoConfig', :member_zone   => '1DemoMemberZone', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end

      it "should not support  long name (64 characters maximum limit)" do
        expect { described_class.new(:configname   => 'Democonfig', :member_zone   => 'abcdefghijknlmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz123456789012', :configstate   => 'enable', :ensure => 'present')}.to raise_error Puppet::Error
      end


    end

    describe "when validating configstate property" do
      it "should support enable" do
        described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'enable', :ensure => 'present')[:configstate].should == :enable
      end

      it "should support disable" do
        described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'disable', :ensure => 'absent')[:configstate].should == :disable
      end

      it "should not support other values" do
        expect { described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'negativetest', :ensure => 'absent') }.to raise_error Puppet::Error
      end

    end

    describe "when validating ensure property" do
      it "should support present" do
        described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'enable', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'disable', :ensure => 'absent')[:ensure].should == :absent
      end

      it "should not support other values" do
        expect { described_class.new(:name => 'zonename:DemoConfig', :configname => 'DemoConfig', :member_zone => 'DemoMemberZone', :configstate => 'disable', :ensure => 'negativetest') }.to raise_error Puppet::Error
      end
    end

  end
end