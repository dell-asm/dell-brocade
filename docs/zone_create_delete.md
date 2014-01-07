# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

  The Brocade switch module uses the SSH protocol to interact with the Brocade switches.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Create Zone
	- Destroy Zone

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Create Zone

     This method creates the zone as per the parameter (zone name) specified in the definition.	 
   
  2. Destroy

     This method deletes the zone from the Brocade switch. 
	 

# -------------------------------------------------------------------------
# Summary of Parameters
# -------------------------------------------------------------------------

    zonename: (Required) This parameter defines the name of the zone that needs to be created or destroyed.

	ensure: (Required) This parameter is required to call the create or destroy method.
            The possible values are: "present" and "absent"
            If the 'ensure' parameter is set to "present", the module calls the 'Create Zone' method.
            If the 'ensure' parameter is set to "absent", the modules calls the 'Destroy Zone' method.

    member: If present, this parameter defines the memberWWPN or alias name of the nodes to be added to the zone. The MemberWWPN or alias name of the member can be used to define the parameter. To specify
            a MemberWWPN, use the format: XX:XX:XX:XX:XX:XX:XX:XX, and alias name can be any string value.
    

# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

#Provide brocade_zone type properties in *.pp manifest file

  brocade_zone { 'Demotitle:
	zonename   => 'Demoname',
    ensure	   => 'present',
    member 	   => 'DemoAlias'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following file contains the details of the sample init.pp and supported files:

    - sample_init.pp_zone
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
