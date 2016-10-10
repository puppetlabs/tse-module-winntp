class winntp (
  Array[String] $servers            = ['time.windows.com'],
  Integer $special_poll_interval    = 900,
  Integer $max_pos_phase_correction = 54000,
  Integer $max_neg_phase_correction = 54000,
  Boolean $purge_unmanaged_servers  = true,
){

  # form the $ntp_servers String from the $servers Array.
  $ntp_servers = join(suffix($servers, ',0x9'), ' ')

  registry_value { 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters\\Type':
    type   => 'string',
    data   => 'NTP',
    notify => Service['w32time'],
  }

  # the list of servers in required space-delimited string format
  registry_value { 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters\\NtpServer':
    type   => 'string',
    data   => $ntp_servers,
    notify => Service['w32time'],
  }

  registry_value { 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\TimeProviders\\NtpClient\\SpecialPollInterval':
    ensure => present,
    type   => 'dword',
    data   => $special_poll_interval,
    notify => Service['w32time'],
  }

  registry_key { 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DateTime\\Servers':
    ensure       => present,
    purge_values => $purge_unmanaged_servers,
  }

  # create a new numbered registry value for each ntp server (1 to $servers.length) 
  $servers.each |$index, $srv| {
    $i = $index + 1
    registry_value { "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DateTime\\Servers\\${i}":
      ensure => present,
      type   => 'string',
      data   => $srv,
      notify => Service['w32time'],
    }
  }

  # default setting is first ntp server (server 1)
  registry_value { 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DateTime\\Servers':
    ensure => present,
    type   => 'string',
    data   => '1',
    notify => Service['w32time'],
  }

  registry_value { 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Config\\MaxPosPhaseCorrection':
    ensure => present,
    type   => 'dword',
    data   => $max_pos_phase_correction,
    notify => Service['w32time'],
  }

  registry_value { 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Config\\MaxNegPhaseCorrection':
    ensure => present,
    type   => 'dword',
    data   => $max_neg_phase_correction,
    notify => Service['w32time'],
  }

  service { 'w32time':
    ensure => running,
    enable => true,
  }
}
