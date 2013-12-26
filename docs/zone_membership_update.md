# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Add member to zone
	- Remove member from zone

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Add member to zone

     This method adds member or member list(semicolon separated) to the zone as per the parameter(member) specified in the definition.	 
   
  2. Remove member from zone

     This method removes member or member list(semicolon separated) from the zone as per the parameter(member) specified in the definition.	 
	 

# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    zonename: (Required) This parameter defines the name of the zone to which member(s) to be added/destroyed.

	ensure: (Required) This parameter is required to call the add or remove method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module adds the specified member(s) to the specified zone.
    If the value of the ensure parameter is set to absent, the module removes the specified member(s) from the specified zone.

    member: (Required) This parameter defines semicolon(;) separated list of member(s) to be added or removed from zone.
	for ex: member1 or member2;member4
    

# -------------------------------------------------------------------------
# Parameter signature 
# -------------------------------------------------------------------------

#Provide brocade_zone type properties in *.pp manifest file

  brocade_zone_membership { 'DemoZone':
	zonename   => 'DemoZone',
    ensure	   => 'present',
    member         => 'DemoMember'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following files capture the details for the sample init.pp and supported files:

    - zonemembership.pp
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
