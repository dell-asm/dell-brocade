module Puppet::Provider::Brocade_messages

        ZONE_MSG_01="Puppet::Provider::brocade_zone: A Brocade zone with zonename: %s, zonemember:  %s is being added."
        ZONE_MSG_02="Puppet::Provider::brocade_zone: A Brocade zone with zonename: %s is being deleted."
	ZONE_MSG_03="Puppet::Provider::brocade_zone: Verifying whether or not a Brocade zone with zonename: %s exists."

        RESPONSE_ZONE_01="not found"
        RESPONSE_ZONE_02="does not exist."
	RESPONSE_ZONE_03="duplicate name"

end
