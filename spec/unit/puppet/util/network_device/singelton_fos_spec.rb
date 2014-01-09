require 'spec_helper'
require 'puppet/util/network_device/singelton_fos'
require 'puppet/util/network_device/brocade_fos/device'

describe Puppet::Util::NetworkDevice::Singelton_fos do
  before(:each) do
    @device = Puppet::Util::NetworkDevice::Brocade_fos::Device.new('ssh://root:pass@127.0.0.1:22/')
    @device.stub(:init).and_return(@device)
  end

  after(:each) do
    Puppet::Util::NetworkDevice::Singelton_fos.clear
  end

  describe 'when initializing the remote network device singleton' do
    it 'should create a network device instance' do
      Puppet::Util::NetworkDevice::Brocade_fos::Device.should_receive(:new).and_return(@device)
      Puppet::Util::NetworkDevice::Singelton_fos.lookup('ssh://127.0.0.1:22/').should == @device
    end

    it 'should cache the network device' do
      Puppet::Util::NetworkDevice::Brocade_fos::Device.should_receive(:new).once.and_return(@device)
      Puppet::Util::NetworkDevice::Singelton_fos.lookup('ssh://127.0.0.1:22/').should == @device
      Puppet::Util::NetworkDevice::Singelton_fos.lookup('ssh://127.0.0.1:22/').should == @device
    end
  end
end
