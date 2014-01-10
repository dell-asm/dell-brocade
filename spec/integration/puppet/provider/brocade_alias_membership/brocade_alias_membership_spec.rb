#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'

describe "Integration test for brocade alias membership" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  let :create_alias do
    Puppet::Type.type(:brocade_alias).new(
    :alias_name  => 'testalias2',
    :ensure   => 'present',
    :member   => '0f:0a:0a:0a:0a:0a:0a:0b',
    )
  end
  let :add_members do
    Puppet::Type.type(:brocade_alias_membership).new(
    :alias_name  => 'testalias2',
    :ensure   => 'present',
    :member   => '1f:2a:0a:0a:0a:0a:0a:0b',
    )
  end
  let :remove_members do
    Puppet::Type.type(:brocade_alias_membership).new(
    :alias_name  => 'testalias2',
    :ensure   => 'absent',
    :member   => '1f:2a:0a:0a:0a:0a:0a:0b',
    )
  end
  let :destroy_alias do
    Puppet::Type.type(:brocade_alias).new(
    :alias_name  => 'testalias2',
    :ensure   => 'absent',
    )
  end
  #Before every test alias will be created
  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    create_alias.provider.device_transport.connect
    create_alias.provider.create
    create_alias.provider.device_transport.close    
  end
  
  #After every test alias will be destroyed
  after :each do
    destroy_alias.provider.device_transport.connect
    destroy_alias.provider.destroy
    destroy_alias.provider.device_transport.close
  end

  context "when add and remove alias members without any error" do
        
    it "should add a member brocade alias" do
      add_members.provider.device_transport.connect
      add_members.provider.create
      response = add_members.provider.device_transport.command(get_alias_show_cmd(add_members[:alias_name]),:noop=>false)
      add_members.provider.device_transport.close
      response.should_not include("does not exist")
    end
    
    it "should delete member from brocade alias" do
      remove_members.provider.device_transport.connect
      remove_members.provider.destroy
      response = remove_members.provider.device_transport.command(get_alias_show_cmd(remove_members[:alias_name]),:noop=>false)
      remove_members.provider.device_transport.close      
      response.should_not include(remove_members[:member])
    end   
  end

  def get_alias_show_cmd(aliasname)
    command = "alishow #{aliasname}"
  end

end

