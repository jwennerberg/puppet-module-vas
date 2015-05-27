# == Class: vas::nis
#
# Manage NIS (vasyp)
#
class vas::nis(
  $package_ensure    = 'installed',
  $service_ensure    = 'running',
  $service_enable    = true,
  $search_base       = undef,
  $domainname        = undef,
  $solaris_vasyppath = undef,
) inherits vas {

  include nisclient

  # Use nisdomainname is supplied. If not, use nisclient::domainname if it
  # exists, last resort fall back to domain fact
  if $domainname == undef {
    if $nisclient::domainname != undef {
      $my_nisdomainname = $nisclient::domainname
    } else {
      $my_nisdomainname = $::domain
    }
  } else {
    $my_nisdomainname = $domainname
  }

  if $::kernel == 'SunOS' {
    case $::kernelrelease {
      '5.9': {
        $service_deps = ['rpc']
        $service_deps_hasstatus = false
      }
      default: {
        $service_deps = ['rpc/bind']
        $service_deps_hasstatus = true
      }
    }
  }

  package { 'vasyp':
    ensure => $package_ensure,
  }

  if $::kernel == 'SunOS' {
    Package['vasyp'] {
      source       => $solaris_vasyppath,
      adminfile    => $vas::solaris_adminpath,
      responsefile => "${vas::solaris_responsepattern}.vasyp",
      provider     => 'sun',
    }
  }

  service { 'vasypd':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Service['vasd'],
    before  => Class['nisclient'],
  }

  if $::kernel == 'SunOS' {
    service { 'vas_deps':
      ensure    => 'running',
      name      => $service_deps,
      enable    => true,
      hasstatus => $service_deps_hasstatus,
      notify    => Service['vasypd'],
    }
  }

}
