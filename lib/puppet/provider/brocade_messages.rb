module Puppet::Provider::Brocade_messages

        ZONE_MSG_01="Puppet::Provider::brocade_zone: A Brocade zone with zonename: %s, zonemember:  %s is being added."
        ZONE_MSG_02="Puppet::Provider::brocade_zone: A Brocade zone with zonename: %s is being deleted."
	ZONE_MSG_03="Puppet::Provider::brocade_zone: Verifying whether or not a Brocade zone with zonename: %s exists."
	CONFIG_DOC="Manage zone config creation, deletion and state change."
	CONFIG_ALREADY_EXIST="Config %s already exists."
	CONFIG_NO_EFFECTIVE_CONFIG="Could not disable the config as no effective configuration found."
	CONFIG_DESTORY_DEBUG="Puppet::Provider::brocade_config: The Config %s is being deleted."
	CONFIG_CREATE_DEBUG="Puppet::Provider::brocade_config: A Config %s with members %s is being created."
	CONFIG_ENABLE_DEBUG="Puppet::Provider::brocade_config: The Config %s is being enabled."
	CONFIG_DISABLE_DEBUG="Puppet::Provider::brocade_config: The current effective Config is being disabled."
	CONFIG_DESTROY_ERROR="Could not delete the config %s because of the following issue: %s"
	CONFIG_CREATE_ERROR="Could not create the config %s because of the following issue: %s"
	CONFIG_ENABLE_ERROR="Could not enable the config %s because of the following issue: %s"
	CONFIG_ENABLE_PROMPT="/Do you want to enable/"
	CONFIG_DISABLE_PROMPT="/Do you want to disable /"
	
	CONFIG_MEMBERSHIP_DOC="Manage addition and removal of zones to config."
	CONFIG_MEMBERSHIP_CREATE_DEBUG="Puppet::Provider::brocade_config_membership: Adding Zone(s) %s to Config %s."
	CONFIG_MEMBERSHIP_CREATE_ERROR="Unable to add the Zone(s) %s to Config %s.Error: %s"
	CONFIG_MEMBERSHIP_ALREADY_EXIST_INFO="Zone(s) %s already added to Config %s"
	CONFIG_MEMBERSHIP_DESTORY_DEBUG="Puppet::Provider::brocade_config_membership: Removing Zone(s) %s from Config %s"
    CONFIG_MEMBERSHIP_ALREADY_REMOVED_INFO="Zone(s) %s already removed from Config %s"
	CONFIG_MEMBERSHIP_DESTROY_ERROR="Unable to remove the Zone(s) %s from Config %s. Error: %s"

end
