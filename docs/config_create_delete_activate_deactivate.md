# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

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

     The create method creates the zone config as per the parameter(config name) specified in the definition.	 
   
  2. Delete Config

     The delete method deletes the zone config from the brocade switch device. 	 

  3. Activate Config

     The activate method enables the zone config on the brocade switch device. 	
	 
  4. De-activate Config

     The deactivate method disables the zone config on the brocade switch device. 	 

# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    configname: (Required) This parameter defines the name of the zone config that needs to be created/deleted.

	ensure: (Required) This parameter is required to call the create or delete method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module calls the create method.
    If the value of the ensure parameter is set to absent, the modules calls the destroy method.

    member_zone: If present, this parameter specifies the semicolon(;) separated list of zone(s) es to be added to the config. 
	
	configstate: If present, this parameter specifies activate or deactivate the specified zone config. Valid values are enable/disable.
    

# -------------------------------------------------------------------------
# Parameter signature 
# -------------------------------------------------------------------------

#Provide brocade_config type properties in *.pp manifest file

  brocade_config { 'Democonfig:
	member_zone   => 'Demozone',
    ensure	   => 'present',
    configstate	=> 'disable'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the examples in the manifest directory.
   The following files capture the details for the sample init.pp and supported files:

    - sample_brocade_config.pp
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
