# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

The Brocade switch module uses the ssh protocol to interact with the brocade switch device.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

	- Add member to alias
	- Remove member from alias

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------


  1. Add member to alias

     This method adds member or member list, separated by semicolons (;), to the alias as per the parameter(member) specified in the definition.	 
   
  2. Remove member from alias

     This method removes member or member list, separated by semicolons (;), from the alias as per the parameter(member) specified in the definition.	 
	 

# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    aliasname: (Required) This parameter defines the name of the alias to which member(s) to be added/removed.

	ensure: (Required) This parameter is required to call the add or remove members from alias.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module adds the specified member(s) to the specified alias.
    If the value of the ensure parameter is set to absent, the module removes the specified member(s) from the specified alias.

    member: (Required) This parameter defines the semicolon(;) separated list of memberWWPNs to be added to the alias. To specify a MemberWWPN, use the format: XX:XX:XX:XX:XX:XX:XX:XX.
    

# -------------------------------------------------------------------------
# Parameter signature 
# -------------------------------------------------------------------------

#Provide brocade_alias_membership type properties in *.pp manifest file

  brocade_alias_membership { 'Demoalias':
    alias_name  => 'demoalias'
	ensure	   => 'present',
    member         => 'DemoMember'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer to the examples in the manifest directory.
    The following file is the sample pp file for adding/removing Members from/to alias.

    - sample_init.pp_alias_membership_update

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
