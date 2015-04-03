# == Class: crashdump
#
# Installs linux-crashdump to configure working crashdumps on Linux
#
# === Parameters
#
# === Examples
#
#  class { crashdump: }
#
# === Authors
#
# Author Name <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2015 Brainsware
#
class crashdump (
  $package_name   = $::crashdump::params::package_name,
  $package_ensure = $::crashdump::params::package_ensure,
  $service_name   = $::crashdump::service_name,
  $service_enable = true,
  $service_ensure = 'running',
  $crashkernel_size = $crashdump::params::crashkernel_size,
) inherits crashdump::params {

  anchor { 'crashdump::begin': } ->
  class { 'crashdump::config': } ->
  class { 'crashdump::install': } ->
  class { 'crashdump::service': } ->
  anchor { 'crashdump::end':}

}
