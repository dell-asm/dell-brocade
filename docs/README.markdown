# Brocade switch device module

**Table of Contents**

- [Brocade switch device module](#Brocade-network-device-module)
	- [Overview](#overview)
	- [Features](#features)
	- [Requirements](#requirements)
	- [Usage](#usage)
		- [Device Setup](#device-setup)
		- [Brocade operations](#Brocade-operations)

## Overview
The Brocade switch device module is designed to provide brocade switch configuration using Puppet.

Following Brocade models have been verified using this module:
- Brocade-6510

However, this module may be compatible with other versions.

## Features
This module supports the following functionality:

 * Alias creation and deletion.
 * Addition and Removal of Members from alias.
 * Zone creation and deletion.
 * Addition and Removal of Members from zones.
 * Config creation and deletion.
 * Addition and Removal of Zones from Config.
 * Activation and De-Activation of Config
 

## Requirements
As a Puppet agent cannot be directly installed on the Brocade Fabric OS, it can either be managed from the Puppet Master server,
or through an intermediate proxy system running a puppet agent. The requirements for the proxy system are still undefined.

## Usage

### Device Setup
To configure a Brocade Fabric OS device, the device *type* must be `brocade_fos`.
The device can either be configured within */etc/puppet/device.conf*, or, preferably, create an individual config file for each device within a sub-folder.
This is preferred as it allows the user to run the puppet against individual devices, rather than all devices configured...

In order to run the puppet against a single device, you can use the following command:

    puppet device --deviceconfig /etc/puppet/device/[device].conf

Example configuration `/etc/puppet/device/brocade_fos1.example.com.conf`:

    [brocade_fos1.example.com]
      type brocade_fos
      url ssh://root:secret@brocade_fos1.example.com:22

### Brocade FOS operations
This module can be used to create/delete an Alias, create/delte a zone, add/remove member from Zone, create/delete config, Activate/De-Activate Config.
For example: 

   brocade_member_alias { 'demoAlias':
    ensure => 'present',
    member => '"50:00:d3:10:00:5e:c4:ad ; 50:00:d3:10:00:5e:c4:ac"'
  }


  brocade_zone { 'demozone':
    ensure => 'present',
    member => 'demoAlias'
  }

 brocade_config { 'democonfig':
   ensure => 'present',
   member_zone => 'demozone',
   configstate => 'disable',
  }


This creates a An Alias for members, Add this Alias to a zone and add the zone to the config(in De-Activation mode) as per defined input parameters.

You can also use any of the above operations individually, or create new defined types, as required. The details of each operation and parameters 
are mentioned in the following readme files, that are shipped with the module:

  -alias_create_delete.md 
  -zone_create_delete.md
  -zone_membership_update.md
  -config_membership_update.md
  -config_create_delete_activate_deactivate.md
  
  
