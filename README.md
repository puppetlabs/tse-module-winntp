# winntp 

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Example usage code with description](#example)
4. [Parameters](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [References - source info for module creation](#references)

##Overview

This module configured NTP servers on Windows machines.

##Module Description

This module requires the [registry](https://forge.puppet.com/puppetlabs/registry) and [stdlib](https://forge.puppet.com/puppetlabs/stdlib) modules that are found at their appropriate links. 

This module configures the w32time service to use a standard time server (time.windows.com) or an array or custom time servers.  It achieves this through registry entries.

##Usage

###Basic OS default example
In this example the module will ensure the w32time service is running and syncronizing with the Microsoft default time.windows.com server:
```puppet
  include 'winntp'
```
###Example of setting the time servers to two custom addresses
In this example the two servers that are passed as variables will be set on all nodes with this classification applied: 
```puppet
  class { 'winntp':
    servers => ['time.nist.gov', 'pool.ntp.org'],
  }
```

##Parameters

The following parameters are available in the `::time` class:

###`servers` (optional)
Specifies the time servers to be set.  
Valid Input: Array of strings
Default: "time.windows.com"

###`special_poll_interval` (optional)
Specifies the poll time in seconds.  
Valid Input: integer
Default: 900

###`max_pos_phase_correction` (optional)
Specifies the max positive (forward) sample time a server can accept in seconds.  
Valid Input: integer
Default: 54000

###`max_neg_phase_correction` (optional)
Specifies the max negetive (backwards) sample time a server can accept in seconds.  
Valid Input: integer
Default: 54000

###`purge_unmanaged_servers` (optional)
Purge servers not specified by this module if they exist.
Valid Input: boolean
Default: true

##Limitations
The module is compatiable with Windows machines.

##References

These reference articles were used to formulate this modules functionality:
[https://technet.microsoft.com/windows-server-docs/identity/ad-ds/get-started/windows-time-service/windows-time-service-tools-and-settings](https://technet.microsoft.com/windows-server-docs/identity/ad-ds/get-started/windows-time-service/windows-time-service-tools-and-settings)
[https://blogs.msdn.microsoft.com/w32time/2008/02/26/configuring-the-time-service-ntpserver-and-specialpollinterval/](https://blogs.msdn.microsoft.com/w32time/2008/02/26/configuring-the-time-service-ntpserver-and-specialpollinterval/)

