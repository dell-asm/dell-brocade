# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

  The Brocade switch module uses the SSH protocol to interact with the Brocade switches.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Create Config
	- Delete Config
	- Activate Config
	- De-activate Config

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Create Config

     This method creates the zone config as per the parameter(config name) specified in the definition.	 
   
  2. Delete Config

     This method deletes the zone config from the Brocade switch. 	 

  3. Activate Config

     This method enables the zone config on the Brocade switch. 	
	 
  4. De-activate Config

     This method disables the zone config on the Brocade switch. 	 

# -------------------------------------------------------------------------
# Summary of Parameters
# -------------------------------------------------------------------------

    configname: (Required) This parameter defines the name of the zone config that needs to be created or deleted.

	ensure: (Required) This parameter is required to call the 'Create Config' or 'Delete Config' method.
            The possible values are: "present" and "absent"
            If the 'ensure' parameter is set to present, the module calls the 'Create Config' method.
            If the 'ensure' parameter is set to absent, the module calls the 'Delete Config' method.

    member_zone: If present, this parameter defines the list of zones, separated by semicolons(;), to be added to the config. 
	
	configstate: If present, this parameter activates or deactivates the specified zone config. 
	             The possible values are: "enable" and "disable" 
	             The Config state can be updated only when 'ensure' parameter is set to "present".
    

# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

#Provide brocade_config type properties in *.pp manifest file

 brocade_config { 'Democonfig' :
	configname  => 'Democonfig',
	member_zone   => 'Demozone',
    ensure	   => 'present',
    configstate	=> 'disable'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following file contains the details of the sample init.pp and supported files:

    - sample_init.pp_config
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
