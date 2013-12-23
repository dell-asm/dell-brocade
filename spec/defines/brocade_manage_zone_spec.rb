require 'spec_helper'

describe Puppet::Type.type(:brocade_manage_zone) do
  let(:title) { 'brocade_manage_zone' }

  it "should have :zonename as its zone name variable" do
    described_class.key_attributes.should == [:zonename]
  end
 
  describe "when validating attributes" do
    [:member, :zonename].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    describe "for ensure" do
      it "should support present" do
        described_class.new(:name => 'member', :zonename => 'zonename', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:name => 'member', :zonename => 'zonename', :ensure => 'absent')[:ensure].should == :absent
      end

      it "should not have a default value" do
        described_class.new(:name => 'member', :zonename => 'zonename')[:ensure].should == nil
      end
    end
  end
end

