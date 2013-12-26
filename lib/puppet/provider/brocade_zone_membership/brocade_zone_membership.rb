require 'puppet/provider/brocade_fos'
require 'puppet/provider/brocade_responses'


Puppet::Type.type(:brocade_zone_membership).provide(:brocade_zone_membership, :parent => Puppet::Provider::Brocade_fos) do
  @doc = "Manage brocade zone member addition and removal from/to zone."

  mk_resource_methods
  def create
    Puppet.debug("Puppet::Provider::brocade_zone_membership: A zone member with the zonename: #{@resource[:zonename]}, zonemember: #{@resource[:member]} is being added to the zone.")
    response = String.new("")
    response = @transport.command("zoneadd #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    if !response.include? Puppet::Provider::brocade_responses::RESPONSE_DUPLICATE_NAME
      cfg_save
    end
  end

  def destroy
    Puppet.debug("Puppet::Provider::brocade_zone_membership: A zone member with the zonename: #{@resource[:zonename]}, zonemember: #{@resource[:member]} is being removed from the zone.")
    response = String.new("")
    response =  @transport.command("zoneremove #{@resource[:zonename]},\"#{@resource[:member]}\"", :noop => false)
    cfg_save
  end

  def exists?
    Puppet.debug("Puppet::Provider::brocade_zone_membership: Verifying whether or not the Brocade zone with zonename: #{@resource[:zonename]} #{@resource[:member]} exists.")
    self.device_transport
    response = String.new("")
    response = @transport.command("zoneshow #{@resource[:zonename]}", :noop => false)
    if (response.match('Puppet::Provider::brocade_responses::RESPONSE_DOES_NOT_EXIST'))
      raise Puppet::Error, "Unable to add a member #{@resource[:member]} to the zone  #{@resource[:zonename]} because of the following issue: #{response}"
    end

    if  @resource[:member].match(/;/)
        zoneMemberList =  @resource[:member].split(";")
    	Puppet.debug("zoneMemberList ########### #{zoneMemberList}")
        for zoneMem in zoneMemberList
    	Puppet.debug("zoneMem in #{zoneMem} ")
        if !response.match(zoneMem)
        	Puppet.debug("Puppet::Provider::brocade_zone_membership: All members are not added:")
    		if "#{@resource[:ensure]}" == "present" 
     		return  false
			end
        end
        end
        Puppet.debug("Puppet::Provider::brocade_zone_membership: All members are already added:")
			return true
	else
    if response.include? @resource[:member]
      Puppet.debug("Puppet::Provider::brocade_zone_membership: member is already added")
    	true
    else
      Puppet.debug("Puppet::Provider::brocade_zone_membership: member is not added:")
    	false
  	end
	end
end
end
