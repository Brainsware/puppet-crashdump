# == Class: crashdump::install
#
# Installs linux-crashdump
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
class crashdump::install {

  package { $crashdump::package_name:
    ensure => $crashdump::package_ensure,
  }

}
