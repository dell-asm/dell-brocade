# Brocade network device module

**Table of Contents**

- [Brocade network device module](#Brocade-network-device-module)
	- [Overview](#overview)
	- [Features](#features)
	- [Requirements](#requirements)
	- [Usage](#usage)
		- [Device Setup](#device-setup)
		- [Brocade operations](#Brocade-operations)

## Overview
The Brocade network device module is designed to add support for managing Brocade switch configuration using Puppet and its Network Device functionality.

Following Brocade models have been verified using this module:
- Brocade-6510

However, this module may be compatible with other versions.

## Features
This module supports the following functionalities:

 * Alias creation and deletion
 * Addition and Removal of Members from Alias
 * Zone creation and deletion
 * Addition and Removal of Members from zones
 * Config creation and deletion
 * Addition and Removal of Zones from Config
 * Activation and De-Activation of Config
 

## Requirements
Because the Puppet agent cannot be directly installed on the Brocade Fabric OS, the agent can be managed either from the Puppet Master server,
or through an intermediate proxy system running a puppet agent. The proxy system requirements are not yet defined.

## Usage

### Device Setup
To configure a Brocade Fabric OS device, the device *type* must be `brocade_fos`.
The device can either be configured within */etc/puppet/device.conf*, or, preferably, create an individual config file for each device within a sub-folder.
This is preferred as it allows the user to run the puppet against individual devices, rather than all devices configured.

To run the puppet against a single device, use the following command:

    puppet device --deviceconfig /etc/puppet/device/[device].conf

Sample configuration `/etc/puppet/device/brocade_fos1.example.com.conf`:

    [brocade_fos1.example.com]
      type brocade_fos
      url ssh://root:secret@brocade_fos1.example.com:22

### Brocade FOS operations
This module can be used to create or delete an Alias, create or delete a zone, add or remove member from a Zone, create or delete config, Activate or Deactivate Config.
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


This creates an Alias for the members, adds the Alias to a zone, and then adds the zone to the config (in Deactivation mode) as per defined input parameters.

You can also use any of the above operations individually, or create new defined types, as required. 