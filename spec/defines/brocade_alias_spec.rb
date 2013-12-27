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
    it "should have aliasname as one of its parameters for alias name" do
      described_class.key_attributes.should == [:alias_name]
    end
    [:alias_name, :member].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    describe "when validating ensure property" do
      it "should support present" do
        described_class.new(:alias_name => 'DemoAlias', :member => '0f:0a:0a:0a:0a:0a:0a:0a', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:alias_name => 'DemoAlias', :member => '0f:0a:0a:0a:0a:0a:0a:0a', :ensure => 'absent')[:ensure].should == :absent
      end

    end
  end
end

