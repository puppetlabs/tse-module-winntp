class winntp (
  $servers               = ['time.windows.com'],
  $special_poll_interval = 900, # 15 minutes
  ) {

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type':
    type => 'string',
    data => 'NTP',
    notify => Service['w32time'],
  }
  
  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config':
    type => 'dword',
    data => '5',
    notify => Service['w32time'],
  }
 
  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\NtpServer':
    type => 'string',
    data => "${servers[0]},0x01",
    notify => Service['w32time'],
  }
  
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient\SpecialPollInterval':
    ensure => present,
    type   => 'dword',
    data   => $special_poll_interval,
    notify => Service['w32time'],
  }
  
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\1':
    ensure => present,
    type   => 'string',
    data   => $servers[0],
    notify => Service['w32time'],
  }
  
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\\':
    ensure => present,
    type   => 'string',
    data   => '1',
    notify => Service['w32time'],
  }
  
  service { 'w32time':
    ensure => running,
    enable => true,
  }
}
