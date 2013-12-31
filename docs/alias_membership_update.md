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

     This method adds member or member list(semicolon separated) to the alias as per the parameter(member) specified in the definition.	 
   
  2. Remove member from alias

     This method removes member or member list(semicolon separated) from the alias as per the parameter(member) specified in the definition.	 
	 

# -------------------------------------------------------------------------
# Summary of parameters.
# -------------------------------------------------------------------------

    alias_name: (Required) This parameter defines the name of the alias to which member(s) to be added/removed.

	ensure: (Required) This parameter is required to call the add or remove method.
    Possible values: present/absent
    If the value of the ensure parameter is set to present, the module adds the specified member(s) to the specified alias.
    If the value of the ensure parameter is set to absent, the module removes the specified member(s) from the specified alias.

    member: (Required) This parameter defines semicolon(;) separated list of member(s) to be added or removed from alias.
	for ex: member1 or member2;member4
    

# -------------------------------------------------------------------------
# Parameter signature 
# -------------------------------------------------------------------------

#Provide brocade_alias_membership type properties in *.pp manifest file

  brocade_alias_membership { 'DemoAlias':
    ensure	   => 'present',
    member         => 'DemoMember'
  }

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer to the examples in the manifest directory.
    The following file is the sample pp file for adding/removing Members from/to Alias.

    - aliasmembership.pp
    
	A user can add the below lines in site.pp to call below pp file by executing "puppet device" command
	node asmbrocade {
	include brocade::aliasmembership
	}

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------	
