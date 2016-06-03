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
# [*ensure*]
#  property to add or remove zone configuration
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
#    ensure => 'present'
#  }
#
define brocade::createzone (
  $storage_alias,
  $server_wwn,
  $zoneset,
  $ensure,
) {
  brocade_zone {
    "$name":
      ensure => "$ensure",
      member => "$storage_alias",
  }
  brocade_zone_membership {
    "$name:$storage_alias":
      ensure => "$ensure",
  }

  brocade_zone_membership {
    "$name:$server_wwn":
      ensure => "$ensure",
  }

  brocade_config_membership {
    "$zoneset:$name":
      ensure => "$ensure",
  }

  brocade_config {
    "$name:$zoneset":
      ensure      => "present",
      member_zone => "$name",
      configstate => "enable",
  }

  if $ensure == 'present'{
    Brocade_zone["$name"]
    -> Brocade_zone_membership["$name:$storage_alias"]
    -> Brocade_zone_membership["$name:$server_wwn"]
    -> Brocade_config_membership["$zoneset:$name"]
    -> Brocade_config["$name:$zoneset"]
  } else  {
    Brocade_config_membership["$zoneset:$name"]
    -> Brocade_zone_membership["$name:$storage_alias"]
    -> Brocade_zone_membership["$name:$server_wwn"]
    -> Brocade_zone["$name"]
    -> Brocade_config["$name:$zoneset"]
  }
}
