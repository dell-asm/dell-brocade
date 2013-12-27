require 'spec_helper'

describe Puppet::Type.type(:brocade_zone) do
  let(:title) { 'brocade_zone' }

  context 'should compile with given test params' do
    let(:params) { {
        :zonename   => 'Demoname',
        :member   => 'DemoAlias',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    it "should have zonename as one of its parameters for zone name" do
      described_class.key_attributes.should == [:zonename]
    end
    [:member, :zonename].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    describe "when validating ensure property" do
      it "should support present" do
        described_class.new(:member => 'member', :zonename => 'zonename', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:member => 'member', :zonename => 'zonename', :ensure => 'absent')[:ensure].should == :absent
      end

    end
  end
end

