# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Create Zone
	- Destroy Zone

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Create Zone

     The create method creates the zone as per the parameter(zone name) specified in the definition.
	 If zoneconfig parameter is also specified in the definition, the created zone is added to it.
   
  2. Destroy

     The destroy method deletes the zone from the brocade switch device. 
	 If zoneconfig parameter is specified in the definition, first the given zone name is removed from it, and then deleted from brocade switch device. 


# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    zonename: (Required) This parameter defines the name of the zone that needs to be created/destroyed.

	ensure: (Required) This parameter is required to call the create or destroy method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module calls the create method.
    If the value of the ensure parameter is set to absent, the modules calls the destroy method.

    member: If present, this parameter specifies the memberWWPN/alias name of the nodes to be added to the zone. MemberWWPN or aliasname of the member can be used to specify the parameter . To specify
         a MemberWWPN, use XX:XX:XX:XX:XX:XX:XX:XX, and alias name can be any string value.

    zoneconfig: If present, this parameter holds the value, to/from which, zone created/deleted needs to be added/removed.

# -------------------------------------------------------------------------
# Parameter signature 
# -------------------------------------------------------------------------

#Provide brocade_zone type properties in *.pp manifest file

  brocade_zone { 'Demotitle:
	zonename   => 'Demoname',
    ensure	   => 'present',
    member 	   => 'DemoAlias',
	zoneconfig => 'Democonfig'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following files capture the details for the sample init.pp and supported files:

    - sample_init.pp
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
