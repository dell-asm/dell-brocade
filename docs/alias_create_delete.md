# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Create Alias
	- Delete Alias

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Create Alias

     The create method creates the alias as per the parameter(alias_name) specified in the definition.	 
   
  2. Delete Alias

     The delete method deletes the alias from the brocade switch device. 	 


# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    alias_name: (Required) This parameter defines the name of the alias that needs to be created/destroyed.

	ensure: (Required) This parameter is required to call the create or destroy method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module calls the create method.
    If the value of the ensure parameter is set to absent, the modules calls the destroy method.

    member: (Required) This parameter specifies the memberWWPN of the nodes to be added to the alias. To specify a MemberWWPN, use XX:XX:XX:XX:XX:XX:XX:XX.
    

# -------------------------------------------------------------------------
# Parameter signature 
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
   The following files capture the details for the sample init.pp and supported files:

    - sample_alias.pp
    
   A user can create an init.pp file based on the above sample files and call the "puppet device" command , for example: 
   # puppet device

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
