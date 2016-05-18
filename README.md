A very simple Puppet module for configuring NTP client on Windows.

This module requires the puppetlabs/registry and puppetlabs/stdlib modules.

# Examples #

```puppet
  include 'winntp'

  class { 'winntp':
    servers => ['time.windows.com', 'time.apple.com', 'pool.ntp.org'],
  }
```
