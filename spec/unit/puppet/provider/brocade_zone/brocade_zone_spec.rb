require 'spec_helper'
require 'fixtures/unit/puppet/provider/brocade_zone/brocade_zone_fixture'

describe "Brocade Zone behavior testing" do

  before(:each) do
    @fixture = Brocade_zone_fixture.new
    mock_transport=double('transport')
    mock_transport.stub(:close)
    @fixture.provider.stub(:transport).and_return(mock_transport)
    @fixture.provider.stub(:cfg_save)
  end

  context "when brocade_zone provider is created " do
    it "should have a create method defined for brocade_zone" do
      @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have a destroy method defined for brocade_zone" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have a exists? method defined for brocade_zone" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

    it "should have a parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)
    end
  end

  context "when brocade zone is created " do
    it "should warn if brocade zone name already exist " do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@fixture.get_zone_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_ALREADY_CONTAINS)
      resp = Puppet::Provider::Brocade_messages::ZONE_ALREADY_EXIST_INFO%[@fixture.get_zone_name]
      Puppet.should_receive(:info).once.with(resp).ordered
      @fixture.provider.should_not_receive(:cfg_save)

      #When
      @fixture.provider.create
    end
  end

  it "should create brocade zone if brocade zone name is not present" do
  #Then
    @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@fixture.get_zone_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return ""
    @fixture.provider.should_receive(:cfg_save).once.ordered

    #When
    @fixture.provider.create
  end

  it "should raise error if response contains 'invalid' while creating brocade zone" do
  #When - Then
    @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@fixture.get_zone_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_INVALID)
    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end

  it "should raise error if response contains 'name too long' while creating brocade zone" do
  #When - Then

    @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_CREATE_COMMAND%[@fixture.get_zone_name,@fixture.get_member_name], NOOP_HASH).ordered.and_return(Puppet::Provider::Brocade_responses::RESPONSE_NAME_TOO_LONG)

    expect {@fixture.provider.create}.to raise_error(Puppet::Error)
  end

  context "when brocade zone is deleted" do
    it "should delete the already existing brocade zone" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_DELETE_COMMAND%[@fixture.get_zone_name], NOOP_HASH).ordered.and_return ("")
      @fixture.provider.should_receive(:cfg_save).once.ordered
      #When
      @fixture.provider.destroy
    end

    it "should warn if brocade zone name does not exist" do
    #Then
      @fixture.provider.transport.should_receive(:command).once.with(Puppet::Provider::Brocade_commands::ZONE_DELETE_COMMAND%[@fixture.get_zone_name], NOOP_HASH).ordered.and_return (Puppet::Provider::Brocade_responses::RESPONSE_DOES_NOT_EXIST)
      resp = Puppet::Provider::Brocade_messages::ZONE_ALREADY_REMOVED_INFO%[@fixture.get_zone_name]
      Puppet.should_receive(:info).once.with(resp).ordered
      @fixture.provider.should_not_receive(:cfg_save)
      #When
      @fixture.provider.destroy
    end

  end

end

