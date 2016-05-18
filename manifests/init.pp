# https://technet.microsoft.com/en-us/library/cc773263.aspx
# https://support.microsoft.com/en-us/kb/939322
# http://www.bytefusion.com/products/ntm/pts/3_3modesofoperation.htm
# https://nchrissos.wordpress.com/2013/04/26/configuring-time-on-windows-2008-r2-servers/
# https://blogs.msdn.microsoft.com/w32time/2008/02/26/configuring-the-time-service-ntpserver-and-specialpollinterval/
class winntp (
  Array[String] $servers            = ['time.windows.com'],
  Variant[String, Undef] $ntpserver = undef,
  Integer $special_poll_interval    = 900, # 15 minutes
  Integer $max_pos_phase_correction = 54000, # 15 hrs
  Integer $max_neg_phase_correction = 54000, # 15 hrs
  ) {

  # if $ntpserver hasn't been provided (still an Undef), form the special
  # $ntp_servers String from the $servers Array.
  if $ntpserver =~ Undef {
    $ntp_servers = join(suffix($servers, ',0x09'), ' ')
  } else {
    $ntp_servers = $ntpserver
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type':
    type => 'string',
    data => 'NTP',
    notify => Service['w32time'],
  }

  # the list of servers in required space-delimited string format
  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\NtpServer':
    type => 'string',
    data => $ntp_servers,
    notify => Service['w32time'],
  }
  
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient\SpecialPollInterval':
    ensure => present,
    type   => 'dword',
    data   => $special_poll_interval,
    notify => Service['w32time'],
  }

  # create a new numbered registry value for each ntp server (1 to $servers.length) 
  $servers.each |$index, $srv| { 
    $i = $index + 1
  registry_value { "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\\${i}":
        ensure => present,
        type   => 'string',
        data   => $srv,
        notify => Service['w32time'],
      }
  }

  # default setting is first ntp server (server 1)
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\\':
    ensure => present,
    type   => 'string',
    data   => '1',
    notify => Service['w32time'],
  }
  
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config\MaxPosPhaseCorrection':
    ensure => present,
    type   => 'dword',
    data   => $max_pos_phase_correction,
    notify => Service['w32time'],
  }

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config\MaxNegPhaseCorrection':
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
