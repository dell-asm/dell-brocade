module Puppet::Provider::Brocade_commands
  ALIAS_CREATE_COMMAND = "alicreate %s, %s"
  ALIAS_DELETE_COMMAND = "alidelete %s"
  ALIAS_SHOW_COMMAND = "alishow %s"
  ALIAS_MEMBER_ADD_COMMAND = "aliadd %s, %s"
  ALIAS_MEMBER_REMOVE_COMMAND = "aliremove %s, %s"
  ZONE_ADD_MEMBER_COMMAND = "zoneadd %s, %s"
  ZONE_REMOVE_MEMBER_COMMAND = "zoneremove %s, %s"
  CONFIG_ADD_MEMBER_COMMAND = "cfgadd %s, %s"
  CONFIG_REMOVE_MEMBER_COMMAND = "cfgremove %s, %s"
end