# == Class: crashdump::config
#
# make sure linux crashdump is configured properly
#
# === Parameters
#
# === Examples
#
#  don't use this class on its own.
#
# === Authors
#
# Author Name <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class crashdump::config {

  $crashkernel_size = $crashdump::crashkernel_size

  case $::osfamily {
    'RedHat' : {
      # XXX this will need an onlyif =>
      exec { 'update grub config':
        command  => "grubby --update-kernel=ALL --args=\"crashkernel=${crashkernel_size}\"",
        pwd      => '/',
        path     => '/sbin:/bin:/usr/bin:/usr/sbin',
        provider => 'posix',
      }
    }
    'Debian' : {
      case $::operatingsystem {
        # This is a hack. We make sure that on Ubuntu the crashkernel line in
        # /etc/grub.d/10_linux isn't something that will just NOT work, see errata:
        #   https://wiki.ubuntu.com/Kernel/CrashdumpRecipe#Release_specific_notes
        #
        # Rationale: We could put this into /etc/default/grub but that would mean
        # potentially messing with other people's grub config. Since there's no
        # way of managing a single part of a single line in a configuration file
        # or any sensible hooks for grub that everyone uses, we keep it simple.
        'Ubuntu' : {
          file_line { 'crashkernel_size':
            path  => '/etc/grub.d/10_linux',
            match => '    GRUB_CMDLINE_EXTRA="\$GRUB_CMDLINE_EXTRA crashkernel=.*',
            line  => "    GRUB_CMDLINE_EXTRA=\"\$GRUB_CMDLINE_EXTRA crashkernel=${crashkernel_size}\"",
          }
        }
        default : {
          # on debian we do something else.
        }
      }
    }
    default : {
      # nothing to do here.
    }
  }


}
