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
# Copyright 2013 Brainsware
#
class crashdump {

  anchor { 'crashdump::begin': } ->
  class { 'crashdump::config': } ->
  class { 'crashdump::install': } ->
  class { 'crashdump::service': } ->
  anchor { 'crashdump::end':}

}
