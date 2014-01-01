# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

  The Brocade switch module uses the SSH protocol to interact with the Brocade switches.

# --------------------------------------------------------------------------
# Supported Functionality
# --------------------------------------------------------------------------

	- Add zone to config
	- Remove zone from config

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Add zone to config

     This method adds zone or zone list, separated by semicolons (;), to the config as per the parameter (member_zone) specified in the definition.	 
   
  2. Remove zone from config

     This method removes zone or zone list, separated by semicolons (;), from the config as per the parameter (member_zone) specified in the definition.	 
	 

# -------------------------------------------------------------------------
# Summary of Parameters
# -------------------------------------------------------------------------

    configname: (Required) This parameter defines the name of the config to which zones to be added or destroyed.

	ensure: (Required) This parameter is required to call the 'Add zone to config' or 'Remove zone from config' method.
            The possible values are: "present" and "absent"
            If the 'ensure' parameter is set to present, the module calls the 'Add zone to config' method.
            If the 'ensure' parameter is set to absent, the modules calls the 'Remove zone from config' method.

    member_zone: (Required) This parameter defines the zones, separated by semicolons(;), to be added or removed from config.
    

# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

#Provide brocade_zone type properties in *.pp manifest file

  brocade_config_membership { 'Democonfig:
	configname   => 'Democonfig',
    ensure	   => 'present',
    member_zone   => 'Demozone'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following file capture the details for the sample init.pp and supported files:

    - sample_init.pp_config_membership_update
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
