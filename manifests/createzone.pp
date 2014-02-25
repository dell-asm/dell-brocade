# == Define: brocade::createzone
#
# Utility for creating zone in brocade switch
#
# === Parameters:
#
# [*server_wwn*]
#   WWN of the server to be added in the zone
#
# [*zoneset*]
#   Name of the zoneset in which the newly created zone will be added
#
# [*storage_alias*]
#   Name of the alias for virtual WWM of the storage
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#  brocade::createzone { 'test_zone':
#    storage_alias => 'cmpl_virtual_ports',
#    server_wwn => '50:00:d3:10:00:5f:a5:00',
#    zoneset => 'Zone_Config',
#  }
#
define brocade::createzone (
        $storage_alias,
        $server_wwn,
        $zoneset,
) {
        brocade_zone {
                "$name":
                        member => "$storage_alias",
                        ensure => "present",
        }

        brocade_zone_membership {
                "$name:$server_wwn":
                        ensure => "present",
        }


        brocade_config_membership {
                "$zoneset:$name":
                        ensure => "present",
        }

        brocade_config {
                "$zoneset":
                        member_zone => "$name",
                        configstate => "enable",
                        ensure => "present",
        }


                Brocade_zone["$name"]
                -> Brocade_zone_membership["$name:$server_wwn"]
                -> Brocade_config_membership["$zoneset:$name"]
                -> Brocade_config["$zoneset"]
}



