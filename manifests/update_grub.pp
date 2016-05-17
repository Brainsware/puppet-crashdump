class crashdump::update_grub {

  # This only works on Ubuntu (and possibly Debian)
  if $::operatingsystem == 'Ubuntu' {
    exec { 'update-grub':
      command     => $::crashdump::params::update_grub_cmd,
      refreshonly => true,
      provider    => 'posix',
    }
  }

}
