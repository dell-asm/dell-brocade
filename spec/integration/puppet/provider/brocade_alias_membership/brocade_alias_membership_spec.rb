#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'spec_lib/puppet_spec/deviceconf'
include PuppetSpec::Deviceconf

describe "Integration test for brocade alias membership" do

  device_conf =  YAML.load_file(my_deviceurl('brocade','device_conf.yml'))

  before :each do
    Facter.stub(:value).with(:url).and_return(device_conf['url'])
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
    :name  => 'testalias2:1f:2a:0a:0a:0a:0a:0a:0b',
    :ensure   => 'present',
    )
  end
  let :remove_members do
    Puppet::Type.type(:brocade_alias_membership).new(
    :name  => 'testalias2:1f:2a:0a:0a:0a:0a:0a:0b',
    :ensure   => 'absent',
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
      member_name = get_member_name(add_members[:name])
      presense?(response,member_name).should == true
    end
    
    it "should delete member from brocade alias" do
      remove_members.provider.device_transport.connect
      remove_members.provider.destroy
      response = remove_members.provider.device_transport.command(get_alias_show_cmd(remove_members[:alias_name]),:noop=>false)
      remove_members.provider.device_transport.close     
      member_name = get_member_name(remove_members[:name]) 
      presense?(response,member_name).should_not == true
    end   
  end

  def get_alias_show_cmd(aliasname)
    command = "alishow #{aliasname}"
  end

  def presense?(response_string,key_to_check)
    retval = false
    if response_string.include?("#{key_to_check}")
    retval = true
    else
    retval = false
    end
    return retval
  end

  def get_member_name(inputString)
    member = inputString.split(':',2)
    return member[1]
  end

end

