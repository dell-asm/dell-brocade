# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Add zone to config
	- Remove zone from config

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Add zone to config

     This method adds zone or zone list(semicolon separated) to the config as per the parameter(member_zone) specified in the definition.	 
   
  2. Remove zone from config

     This method removes zone or zone list(semicolon separated) from the config as per the parameter(member_zone) specified in the definition.	 
	 

# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    configname: (Required) This parameter defines the name of the config to which zone(s) to be added/destroyed.

	ensure: (Required) This parameter is required to call the add or remove method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module calls the create method.
    If the value of the ensure parameter is set to absent, the modules calls the destroy method.

    member_zone: (Required) This parameter defines semicolon(;) separated list of zones to be added or removed from config.
    

# -------------------------------------------------------------------------
# Parameter signature 
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
   The following files capture the details for the sample init.pp and supported files:

    - sample_config_membership.pp
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
