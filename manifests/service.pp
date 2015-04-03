# == Class: crashdump::service
#
# ensures thee kdump service is enabled
#
# === Parameters
#
# === Examples
#
#  Don't use this class directly
#
# === Authors
#
# Author Name <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2015 Brainsware
#
class crashdump::service {

  service { 'crashdump':
    ensure => $::crashdump::service_ensure,
    enable => $::crashdump::service_enable,
    name   => $::crashdump::service_name,
  }

}
