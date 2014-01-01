# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

  The Brocade switch module uses the SSH protocol to interact with the Brocade switches.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

  - Create Alias
  - Delete Alias

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Create Alias

     This method creates the alias as per the parameter (alias_name) specified in the definition.	 
   
  2. Delete Alias

     This method deletes the alias from the Brocade switch. 	 


# -------------------------------------------------------------------------
# Summary of Parameters
# -------------------------------------------------------------------------

    alias_name: (Required) This parameter defines the name of the alias that needs to be created or destroyed.

	ensure: (Required) This parameter is required to call the 'Create Alias' or 'Delete Alias' method.
            The possible values are: "present" or "absent"
            If the 'ensure' parameter is set to "present", the module calls the 'Create Alias' method.
            If the 'ensure' parameter is set to "absent", the module calls the 'Delete Alias' method.

    member: (Required) This parameter defines the memberWWPN of the nodes to be added to the alias. To specify a MemberWWPN, use the format: XX:XX:XX:XX:XX:XX:XX:XX.
    

# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

#Provide brocade_alias type properties in *.pp manifest file

  brocade_alias { 'Demotitle:
	alias_name   => 'Demoname',
    ensure	   => 'present',
    member 	   => '50:00:d3:10:00:5e:c4:35'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following file contains the details of the sample init.pp and supported files:

    - sample_init.pp_alias
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
