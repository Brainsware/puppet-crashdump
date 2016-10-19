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
        cwd      => '/',
        path     => '/sbin:/bin:/usr/bin:/usr/sbin',
        provider => 'posix',
      }
    }
    'Debian' : {
      case $::operatingsystem {
        'Ubuntu' : {
          case $::lsbdistrelease {
            '12.04' : {
              # This is a hack. We make sure that on Ubuntu the crashkernel line in
              # /etc/grub.d/10_linux isn't something that will just NOT work, see errata:
              #   https://wiki.ubuntu.com/Kernel/CrashdumpRecipe#Release_specific_notes
              #
              # Rationale: We could put this into /etc/default/grub but that would mean
              # potentially messing with other people's grub config. Since there's no
              # way of managing a single part of a single line in a configuration file
              # or any sensible hooks for grub that everyone uses, we keep it simple.
              file_line { 'crashkernel_size':
                path   => '/etc/grub.d/10_linux',
                match  => '    GRUB_CMDLINE_EXTRA="\$GRUB_CMDLINE_EXTRA crashkernel=.*',
                line   => "    GRUB_CMDLINE_EXTRA=\"\$GRUB_CMDLINE_EXTRA crashkernel=${crashkernel_size}\"",
                notify => Class['::crashdump::update_grub'],
              }
            }
            '14.04', '16.04' : {
              # On Ubuntu 14.04 the kexec-tools package installs
              # /etc/default/grub.d/kexec-tools.cfg. This is the place to set
              # the crashkernel size. The default size is *still* way too small
              # for systems with more than a gigabyte of RAM, leading to the
              # crash kernel crashing. See
              # https://wiki.ubuntu.com/Kernel/CrashdumpRecipe#Release_specific_notes
              # for more.
              file { '/etc/default/grub.d/kexec-tools.cfg':
                ensure  => 'present',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                content => template("${module_name}/kexec-tools.cfg.erb"),
                notify  => Class['::crashdump::update_grub'],
              }

              # Need to enable the use of kdump. This requires a reboot, of course.
              file_line { 'use_kdump':
                path  => '/etc/default/kdump-tools',
                match => 'USE_KDUMP=.*',
                line  => 'USE_KDUMP=1',
              }
            }
            default: {
              # Nothing yet, but if Ubuntu 18.04 works the same as 14.04/16.04 then we
              # will manage /etc/default/grub.d/kexec-tools.cfg here for 14.04,
              # 16.04 and 18.04.
            }
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
