# Abstracts all device commands in brocade module
module Puppet::Provider::Brocade_commands
  
  ALIAS_CREATE_COMMAND = "alicreate %s, \"%s\""
  ALIAS_DELETE_COMMAND = "alidelete %s"
  ALIAS_SHOW_COMMAND = "alishow %s"
  ALIAS_MEMBER_ADD_COMMAND = "aliadd %s, \"%s\""
  ALIAS_MEMBER_REMOVE_COMMAND = "aliremove %s, \"%s\""
  ZONE_ADD_MEMBER_COMMAND = "zoneadd %s, \"%s\""
  ZONE_REMOVE_MEMBER_COMMAND = "zoneremove %s, \"%s\""
  ZONE_SHOW_COMMAND = "zoneremove %s"
  ZONE_CREATE_COMMAND = "zonecreate %s, \"%s\""
  ZONE_DELETE_COMMAND = "zonedelete %s"
  CONFIG_ADD_MEMBER_COMMAND = "cfgadd %s, \"%s\""
  CONFIG_REMOVE_MEMBER_COMMAND = "cfgremove %s, \"%s\""
  CONFIG_SHOW_COMMAND = "cfgshow %s"
  CONFIG_CREATE_COMMAND = "cfgcreate %s, \"%s\""
  CONFIG_DELETE_COMMAND = "cfgdelete %s"
  CONFIG_ENABLE_COMMAND = "cfgenable %s"
  CONFIG_ACTV_SHOW_COMMAND = "cfgActvShow"
  CONFIG_DISABLE_COMMAND = "cfgDisable"
  YES_COMMAND = "yes"
end