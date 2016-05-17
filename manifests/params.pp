# == Class: crashdump::params
#
# basic parameters - this is where we do "platform independence"...
#
# === Variables
#
# === Authors
#
# Author Name <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2015 Brainsware
#
class crashdump::params {

  $package_ensure = 'installed'
  $package_name   = $::osfamily? {
    'Debian' => [ 'linux-crashdump', 'kexec-tools' ],
    'RedHat' => [ 'crash', 'kexec-tools' ],
  }

  # This is not a running service, it just loads the crash kernel
  $service_ensure = undef
  $service_name   = $::lsbdistcodename? {
    'trusty' => 'kexec-load',
    default  => 'kdump',
  }
  $service_enable = true

  # These rounded numbers (1800, 3800, ...) are based on the values of
  # memorysize_mb on systems that nominally have 2GB, 4GB, ... of RAM.

  # XXX: This logic might be slightly flawed because memorysize_mb shrinks by
  # the amount of reserved memory for the crashkernel.
  if $::memorysize_mb <= '1800' {
    $crashkernel_size = '128M'
  } elsif $::memorysize_mb > '1800' and $::memorysize_mb <= '3800' {
    $crashkernel_size = '256M'
  } elsif $::memorysize_mb > '3800' {
    $crashkernel_size = '512M'
  } # ... this might need to be extended for systems with even more memory.

  $update_grub_cmd = $::operatingsystem ? {
    'Ubuntu' => '/usr/sbin/update-grub',
    default  => undef
  }
}
