require 'spec_helper'

describe Puppet::Type.type(:brocade_zone_membership) do
  let(:title) { 'brocade_zone_membership' }

  context 'should compile with given test params' do
    let(:params) { {
        :name   => 'demozone:memberzone1;memberzone2',
        :ensure   => 'present',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  it "should have name as one of its parameters for zone name" do
    described_class.key_attributes.should == [:name]
  end
  context "when validating attributes" do

    [:name,:member, :zonename].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end
    [:ensure].each do |prop|
      it "should have a #{prop} property" do
        described_class.attrtype(prop).should == :property
      end
    end
    context "when validating values" do
      describe "validating name param" do
        it "should be a tuple of two values" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'present')[:name].should == 'demozone:memberzone1;memberzone2'
        end

        it "should have zone name value before first splitter(:)" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'present')[:zonename].should == 'demozone'
        end

        it "should have member value(s) after first splitter(:)" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'present')[:member].should == 'memberzone1;memberzone2'
        end

      end

      describe "validating zonename variable" do

        it "should support an alphanumerical name" do
          described_class.new(:name => 'zonename1:memberzone1;memberzone2', :ensure => 'present')[:zonename].should == 'zonename1'
        end
        it "should not start with a numerical character in name" do
          expect {described_class.new(:name => '1zonename:memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
        it "should not support long names (more than 64 characters) in name" do

          expect {described_class.new(:name => 'zonenamefffffffffffffffffffffffffffffffffffffffffffffffffffffffff:memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
        it "should support underscores" do
          described_class.new(:name => 'zonename_1:memberzone1;memberzone2', :ensure => 'present')[:zonename].should == 'zonename_1'
        end

        it "should not support blank value" do
          expect {described_class.new(:name => ':memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end

        it "should not support special characters" do
          expect { described_class.new(:name => 'demo@#$%zone:memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
      end

      describe "validating member variable" do

        it "should support semicolon separated list of zonename and member" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'present')[:member].should == 'memberzone1;memberzone2'
        end
        it "should not start with a numerical character in name" do
          expect {described_class.new(:name => 'zonename:2memberzone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
        it "should not support long names (more than 64 characters) in name" do
          expect {described_class.new(:name => 'zonenamefffffffffffffffffffffffffffffffffffffffffffffffffffffffff:memberzofffffffffffffffffffffffffffffffffffffffffffffffffffffffffdd;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
        it "should not support empty member list" do
          expect {described_class.new(:name => 'demozone:', :ensure => 'present')}.to raise_error Puppet::Error
        end

        it "should not support special characters for member list" do
          expect { described_class.new(:name => 'demozone:member@#$%^zone1;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end

        it "should not support invalid wwpn format" do
          expect { described_class.new(:name => 'demozone:0a:0a:0a:0a:0a:0a:0a;memberzone2', :ensure => 'present')}.to raise_error Puppet::Error
        end
      end
      describe "validating ensure property" do
        it "should support present" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'present')[:ensure].should == :present
        end
        it "should support absent" do
          described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'absent')[:ensure].should == :absent
        end
        it "should not support other values" do
          expect { described_class.new(:name => 'demozone:memberzone1;memberzone2', :ensure => 'unsupportedvalue')}.to raise_error Puppet::Error
        end
      end
    end

  end
end

