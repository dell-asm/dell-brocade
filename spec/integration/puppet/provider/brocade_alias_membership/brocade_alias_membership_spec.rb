#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/transport_fos/ssh'


describe "Integration test for brocade alias membership" do
  
  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do    
    Facter.stubs(:value).with(:url).returns(device_conf['url'])      
  end

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
    Puppet::Type.type(:brocade_alias).new(
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
  
  context "when add and remove alias members without any error" do
    it "should create a brocade alias" do  
      create_alias.provider.device_transport.connect  
      create_alias.provider.create
      response = create_alias.provider.device_transport.command(get_alias_show_cmd(create_alias[:alias_name]),:noop=>false)
      response.should_not include("does not exist")        
    end
    it "should add a member brocade alias" do  
      add_members.provider.device_transport.connect  
      add_members.provider.create
      response = add_members.provider.device_transport.command(get_alias_show_cmd(add_members[:alias_name]),:noop=>false)    
      response.should_not include("does not exist")              
    end
    it "should delete member from brocade alias" do     
      remove_members.provider.device_transport.connect  
      remove_members.provider.destroy
      response = remove_members.provider.device_transport.command(get_alias_show_cmd(remove_members[:alias_name]),:noop=>false)
     # response.should include("does not exist")   
    end
    it "should delete the brocade alias" do     
      destroy_alias.provider.device_transport.connect  
      destroy_alias.provider.destroy
      response = destroy_alias.provider.device_transport.command(get_alias_show_cmd(destroy_alias[:alias_name]),:noop=>false)
      response.should include("does not exist")   
    end
  end
  
  def get_alias_show_cmd(aliasname)
    command = "alishow #{aliasname}"    
  end

end

