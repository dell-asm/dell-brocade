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
  
   it "should have zonename as one of its parameters for zone name" do
      described_class.key_attributes.should == [:zonename]
    end

  context "when validating attributes" do   
    [:member, :zonename].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
	  
	 [:ensure].each do |prop|
      it "should have a #{prop} property" do
        described_class.attrtype(prop).should == :property
      end
    end 
    end

  context "when validating values" do

    describe "validating zonename variable" do

      it "should support an alphanumerical name" do
        described_class.new(:member => 'member', :zonename => 'zonename1', :ensure => 'present')[:zonename].should == 'zonename1'
      end

      it "should support underscores" do
        described_class.new(:member => 'member', :zonename => 'zonename_1', :ensure => 'present')[:zonename].should == 'zonename_1'
      end
        
		  it "should not support blank value" do
        expect { described_class.new(:member => 'member', :zonename => '', :ensure => 'present')}.to raise_error(Puppet::Error, /Unable to perform the operation because the zone name is blank/)
      end
		
      it "should not support special characters" do
        expect { described_class.new(:member => 'member', :zonename => 'zonename#$%11', :ensure => 'present')}.to raise_error(Puppet::Error, /Unable to perform the operation because the zone name contains special characters./)
      end
    end

    describe "validating member variable" do

      it "should support semicolon separated list of alias and wwpn" do
        described_class.new(:member => 'demoalias1;50:00:d3:10:00:5e:c4:ad', :zonename => 'zonename', :ensure => 'present')[:member].should == 'demoalias1;50:00:d3:10:00:5e:c4:ad'
      end

      it "should not support empty member list" do
        expect { described_class.new(:member => '', :zonename => 'zonename', :ensure => 'present')}.to raise_error(Puppet::Error, /Unable to perform the operation because the alias name is blank./)
      end

      it "should not support special characters for alias" do
        expect { described_class.new(:member => 'a#$%^&', :zonename => 'zonename', :ensure => 'present')}.to raise_error(Puppet::Error, /Unable to perform the operation because the alias name contains special characters./)
      end

      it "should not support invalid wwpn format" do
        expect { described_class.new(:member => '50:00:d3:10:00:5e:c4:ad:1', :zonename => 'zonename', :ensure => 'present')}.to raise_error(Puppet::Error, /A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format./)
      end
    end

    describe "validating ensure property" do

      it "should support present" do
        described_class.new(:member => 'member', :zonename => 'zonename', :ensure => 'present')[:ensure].should == :present
      end

      it "should support absent" do
        described_class.new(:member => 'member', :zonename => 'zonename', :ensure => 'absent')[:ensure].should == :absent
      end

      it "should not support other values" do
        expect { described_class.new(:member => 'member', :zonename => 'zonename', :ensure => 'negativetest') }.to raise_error(Puppet::Error, /Invalid value "negativetest"/)
      end
    end
    end

  end
end

