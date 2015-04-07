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
  $service_name   = $::crashdump::params::service_name,
  $service_enable = $::crashdump::params::service_enable,
  $service_ensure = $::crashdump::params::service_ensure,
  $crashkernel_size = $crashdump::params::crashkernel_size,
) inherits crashdump::params {

  include 'crashdump::install'
  include 'crashdump::config'
  include 'crashdump::service'

  anchor { 'crashdump::begin': } ->
  Class['crashdump::install'] ->
  Class['crashdump::config'] ->
  Class['crashdump::service'] ->
  anchor { 'crashdump::end': }

  Class['crashdump::install']
  -> Class['crashdump::config']

  Class['crashdump::install']
  ~> Class['crashdump::service']

  Class['crashdump::config']
  ~> Class['crashdump::service']

}
