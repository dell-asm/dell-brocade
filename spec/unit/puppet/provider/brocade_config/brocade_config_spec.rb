require 'spec_helper'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'
require 'fixtures/unit/puppet/provider/brocade_config/brocade_config_fixture'

NOOP_HASH = { :noop => false}
ENABLE_PROMPT_HASH = {:prompt => Puppet::Provider::Brocade_messages::CONFIG_ENABLE_PROMPT}
DISABLE_PROMPT_HASH = {:prompt => Puppet::Provider::Brocade_messages::CONFIG_DISABLE_PROMPT}

describe "Brocade_config" do

  before(:each) do
    @fixture = Brocade_config_fixture.new
    mock_transport=double('transport')
    @fixture.provider.transport = mock_transport
    @fixture.provider.stub(:cfg_save)
    Puppet.stub(:info)
    Puppet.stub(:debug)
  end

  context "when brocade config provider is created " do
    it "should have create method defined for brocade_config" do
      @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have destroy method defined for brocade_config" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_config" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)
    end
  end

  context "when brocade config is created and/or its state is changed" do
    it "should warn if brocade config name already exist and process the brocade config state" do
      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return ("")
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::CONFIG_ALREADY_EXIST%[@fixture.get_config_name]).ordered
      @fixture.provider.should_receive(:process_config_state).once.ordered.and_return ("")
      @fixture.provider.should_not_receive(:cfg_save)
	  
      #When
      @fixture.provider.create
    end

    it "should create brocade config if brocade config name is not present and process the brocade config state" do
      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).ordered.and_return("")
      @fixture.provider.should_receive(:cfg_save).once.ordered
      @fixture.provider.should_receive(:process_config_state).once.ordered.and_return ("")

      #When
      @fixture.provider.create
    end

    it "should raise error if response contains 'invalid' while creating brocade config" do
      #When - Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
      @fixture.provider.should_not_receive(:cfg_save)

      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should raise error if response contains 'name too long' while creating brocade config" do
      #When - Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_create_command, NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)
      @fixture.provider.should_not_receive(:cfg_save)

      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should enable the brocade config state when brocade config state value is enabled in resource" do
      #Given
      @fixture.set_configstate_enable

      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:process_config_state).once.ordered.and_call_original
      @fixture.provider.should_receive(:config_enable).once.ordered.and_call_original
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_enable_command, ENABLE_PROMPT_HASH).ordered.and_return ("")
      @fixture.provider.transport.should_receive(:command).once.with("yes", NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_not_receive(:cfg_save)
      
      #When
      @fixture.provider.create
    end

    it "should raise error if response contains 'not found' while enabling the brocade config state" do
      #Given
      @fixture.set_configstate_enable

      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:process_config_state).ordered.once.and_call_original
      @fixture.provider.should_receive(:config_enable).ordered.once.and_call_original
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_enable_command, ENABLE_PROMPT_HASH).ordered.and_return ("")
      @fixture.provider.transport.should_receive(:command).once.with("yes", NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
    end

    it "should disable the brocade config state when brocade config state value is disabled in resource" do
      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:process_config_state).ordered.once.and_call_original
      @fixture.provider.should_receive(:config_disable).ordered.once.and_call_original
      @fixture.provider.transport.should_receive(:command).once.with("cfgActvShow", NOOP_HASH).ordered.and_return ("")
      @fixture.provider.transport.should_receive(:command).once.with("cfgDisable", DISABLE_PROMPT_HASH).ordered.and_return ("")
      @fixture.provider.transport.should_receive(:command).once.with("yes", NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.create
    end

    it "should warn if no effective brocade config found while disabling the brocade config state" do
      #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_show_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:process_config_state).ordered.once.and_call_original
      @fixture.provider.should_receive(:config_disable).ordered.once.and_call_original
      @fixture.provider.transport.should_receive(:command).once.with("cfgActvShow", NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_NO_EFFECTIVE_CONFIG)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::CONFIG_NO_EFFECTIVE_CONFIG).ordered
      @fixture.provider.should_not_receive(:cfg_save)
      
      #When
      @fixture.provider.create
    end

  end

  context "when brocade config is deleted" do
    it "should delete the already existing brocade config" do
	    #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_delete_command, NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:cfg_save).ordered.once
      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade config name does not exist" do
	  #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_delete_command, NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_NOT_FOUND)
      Puppet.should_receive(:info).once.with(Puppet::Provider::Brocade_messages::CONFIG_ALREADY_REMOVED_INFO%[@fixture.get_config_name]).ordered
      @fixture.provider.should_not_receive(:cfg_save)
      #When
      @fixture.provider.destroy
    end

    it "should raise error if response contains 'should not be deleted'" do
	  #Then
      @fixture.provider.transport.should_receive(:command).once.with(@fixture.provider.get_brocade_config_delete_command, NOOP_HASH).and_return (Puppet::Provider::Brocade_responses::RESPONSE_SHOULD_NOT_BE_DELETED)
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      expect {@fixture.provider.destroy}.to raise_error(Puppet::Error)
    end

  end

  context "when brocade config existence is validated" do
    it "should return false when the brocade config existence is required" do
      #When - Then
      @fixture.provider.should_receive(:device_transport).once
      @fixture.provider.exists?.should == false
    end

    it "should return true when the brocade config existence is not required" do
      #Given
      @fixture.set_config_ensure_absent

      #When - Then
      @fixture.provider.should_receive(:device_transport).once
      @fixture.provider.exists?.should == true
    end

  end

end