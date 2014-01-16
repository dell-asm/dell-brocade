require 'spec_helper'

describe Puppet::Type.type(:brocade_alias) do
  let(:title) { 'brocade_alias' }

  context 'should compile with given test params' do
    let(:params) { {
        :alias_name   => 'DemoAlias',
        :member   => '0f:0a:0a:0a:0a:0a:0a:0a',
        :ensure   => 'present',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    it "should have alias name as its keyattribute" do
      described_class.key_attributes.should == [:alias_name]
    end
    describe "when validating attributes type" do
      [:alias_name, :member].each do |param|
        it "should hava a #{param} parameter" do
          described_class.attrtype(param).should == :param
        end
      end

      [:ensure].each do |property|
        it "should have a #{property} property" do
          described_class.attrtype(property).should == :property
        end
      end
    end
    describe "when validating values" do
      describe "validating alias_name param" do
        it "should allow a valid alias name " do
          described_class.new(:alias_name => 'alias_demo', :ensure => 'present',:member => '0f:0a:0a:0a:0a:0a:0a:0a')[:alias_name].should == 'alias_demo'
        end

        it "should not allow blank value in the alias name" do
          expect { described_class.new(:alias_name => '', :ensure => 'present',:member => '0f:0a:0a:0a:0a:0a:0a:0a') }.to raise_error Puppet::Error
        end
        it "should not allow special characters in the alias name" do
          expect { described_class.new(:alias_name => '$%^&!', :ensure => 'present',:member => '0f:0a:0a:0a:0a:0a:0a:0a') }.to raise_error Puppet::Error
        end
      end
      describe "validating ensure property" do
        it "should support present value" do
          described_class.new(:alias_name => 'DemoAlias', :member => '0f:0a:0a:0a:0a:0a:0a:0a', :ensure => 'present')[:ensure].should == :present
        end

        it "should support absent value" do
          described_class.new(:alias_name => 'DemoAlias', :member => '0f:0a:0a:0a:0a:0a:0a:0a', :ensure => 'absent')[:ensure].should == :absent
        end
        it "should not allow values other than present or absent" do
          expect { described_class.new(:alias_name => 'alias_demo', :ensure => 'foo',:member => '0f:0a:0a:0a:0a:0a:0a:0a') }.to raise_error Puppet::Error
        end

      end
      describe "validating member param" do
        it "should allow a valid member wwpn format" do
          described_class.new(:alias_name => 'alias_demo', :ensure => 'present',:member => '0f:0a:0a:0a:0a:0a:0a:0a')[:member].should == '0f:0a:0a:0a:0a:0a:0a:0a'
        end

        it "should not allow blank member name" do
          expect { described_class.new(:alias_name => 'alias_demo_new', :ensure => 'present',:member => '')}.to raise_error Puppet::Error
        end
        it "should not allow special char in the member value" do
          expect { described_class.new(:alias_name => 'alias_demo_new', :ensure => 'present',:member => '0%:0a:0a:0a:0a:0a:0a:0a') }.to raise_error Puppet::Error
        end
        it "should not allow invalid WWPN in the member value" do
          expect { described_class.new(:alias_name => 'alias_demo_new', :ensure => 'present',:member => '0f:0a:0a:0a:0a:0a:0a') }.to raise_error Puppet::Error
        end
      end
    end
  end
end
