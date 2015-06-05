# == Class: vas
#
# Puppet module to manage VAS - Quest Authentication Services
#
class vas (
  $package_version                                      = undef,
  $enable_group_policies                                = true,
  $enable_nis                                           = true,
  $manage_nss                                           = true,
  $manage_pam                                           = true,
  $users_allow_entries                                  = undef,
  $users_allow_hiera_merge                              = false,
  $users_deny_entries                                   = undef,
  $users_deny_hiera_merge                               = false,
  $user_override_entries                                = undef,
  $group_override_entries                               = undef,
  $join_username                                        = undef,
  $join_password                                        = undef,
  $join_keytab_ensure                                   = 'present',
  $join_keytab_path                                     = '/etc/vasinst.key',
  $join_keytab_source                                   = undef,
  $join_keytab_owner                                    = 'root',
  $join_keytab_group                                    = 'root',
  $join_keytab_mode                                     = '0400',
  $join_debug_flag                                      = undef,
  $computer_object_name                                 = undef,
  $computer_object_container                            = undef,
  $user_search_path                                     = undef,
  $group_search_path                                    = undef,
  $upm_search_path                                      = undef,
  $realm                                                = undef,
  $sitenameoverride                                     = undef,
  $workstation_mode                                     = false,
  $vas_config_path                                      = '/etc/opt/quest/vas/vas.conf',
  $vas_config_owner                                     = 'root',
  $vas_config_group                                     = 'root',
  $vas_config_mode                                      = '0644',
  $vas_user_override_ensure                             = 'present',
  $vas_user_override_path                               = '/etc/opt/quest/vas/user-override',
  $vas_user_override_owner                              = 'root',
  $vas_user_override_group                              = 'root',
  $vas_user_override_mode                               = '0644',
  $vas_group_override_ensure                            = 'present',
  $vas_group_override_path                              = '/etc/opt/quest/vas/group-override',
  $vas_group_override_owner                             = 'root',
  $vas_group_override_group                             = 'root',
  $vas_group_override_mode                              = '0644',
  $vas_users_allow_ensure                               = 'present',
  $vas_users_allow_path                                 = '/etc/opt/quest/vas/users.allow',
  $vas_users_allow_owner                                = 'root',
  $vas_users_allow_group                                = 'root',
  $vas_users_allow_mode                                 = '0644',
  $vas_users_deny_ensure                                = 'present',
  $vas_users_deny_path                                  = '/etc/opt/quest/vas/users.deny',
  $vas_users_deny_owner                                 = 'root',
  $vas_users_deny_group                                 = 'root',
  $vas_users_deny_mode                                  = '0644',
  $vasjoin_logfile                                      = '/var/tmp/vasjoin.log',
  $vastool_binary                                       = '/opt/quest/bin/vastool',
  $symlink_vastool_binary_target                        = '/usr/bin/vastool',
  $symlink_vastool_binary                               = false,
  $license_files                                        = undef,
  $solaris_vasclntpath                                  = undef,
  $solaris_vasgppath                                    = undef,
  $solaris_adminpath                                    = undef,
  $solaris_responsepattern                              = undef,
) {

  validate_absolute_path($vas_config_path)
  validate_absolute_path($vas_users_allow_path)
  validate_absolute_path($vas_users_deny_path)
  validate_absolute_path($vas_user_override_path)
  validate_absolute_path($vas_group_override_path)

  if $license_files != undef {
    validate_hash($license_files)

    $license_files_defaults = {
      'ensure' => 'file',
      'path' => '/etc/opt/quest/vas/.licenses/VAS_license',
      'require' => Package['vasclnt'],
    }

    create_resources(file, $license_files, $license_files_defaults)
  }

  if $computer_object_name != undef {
    $computer_object_name_real = $computer_object_name
  } else {
    $computer_object_name_real = $::fqdn
  }

  if !is_domain_name($computer_object_name_real) {
    fail("vas::computer_object_name is not a valid FQDN. Detected value is <${computer_object_name_real}>.")
  }

  if is_string($users_allow_hiera_merge) {
    $users_allow_hiera_merge_real = str2bool($users_allow_hiera_merge)
  } else {
    $users_allow_hiera_merge_real = $users_allow_hiera_merge
  }
  validate_bool($users_allow_hiera_merge_real)

  if is_string($users_deny_hiera_merge) {
    $users_deny_hiera_merge_real = str2bool($users_deny_hiera_merge)
  } else {
    $users_deny_hiera_merge_real = $users_deny_hiera_merge
  }
  validate_bool($users_deny_hiera_merge_real)

  if is_string($workstation_mode) {
    $workstation_mode_real = str2bool($workstation_mode)
  } else {
    $workstation_mode_real = $workstation_mode
  }

  if is_string($symlink_vastool_binary) {
    $symlink_vastool_binary_bool = str2bool($symlink_vastool_binary)
  } else {
    $symlink_vastool_binary_bool = $symlink_vastool_binary
  }
  validate_bool($symlink_vastool_binary_bool)

  if is_string($enable_group_policies) {
    $enable_group_policies_real = str2bool($enable_group_policies)
  } else {
    $enable_group_policies_real = $enable_group_policies
  }
  validate_bool($enable_group_policies_real)

  if is_string($enable_nis) {
    $enable_nis_real = str2bool($enable_nis)
  } else {
    $enable_nis_real = $enable_nis
  }
  validate_bool($enable_nis_real)

  if is_string($manage_nss) {
    $manage_nss_real = str2bool($manage_nss)
  } else {
    $manage_nss_real = $manage_nss
  }
  validate_bool($manage_nss_real)

  if is_string($manage_pam) {
    $manage_pam_real = str2bool($manage_pam)
  } else {
    $manage_pam_real = $manage_pam
  }
  validate_bool($manage_pam_real)

  case $::kernel {
    'Linux': {
      case $::osfamily {
        'Debian','Suse','RedHat': { }
        default: {
          fail("Vas supports Debian, Suse, and RedHat. Detected osfamily is <${::osfamily}>")
        }
      }
    }
    'SunOS': {
      case $::kernelrelease {
        '5.9','5.10','5.11': { }
        default: {
          fail("Vas supports Solaris kernelrelease 5.9, 5.10 and 5.11. Detected kernelrelease is <${::kernelrelease}>")
        }
      }
    }
    default: {
      fail("Vas module support Linux and SunOS kernels. Detected kernel is <${::kernel}>")
    }
  }

  if $manage_nss_real == true {
    include nsswitch
  }

  if $manage_pam_real == true {
    include pam
  }

  if $enable_nis_real == true {
    include vas::nis
  }

  if $package_version == undef {
    $package_ensure = 'installed'
  } else {
    if $::kernel == 'SunOS' {
      $package_ensure = 'installed'
    } else {
      $package_ensure = $package_version
    }

    $vasver = regsubst($package_version, '-', '.')
    if ($::vas_version and $vasver > $::vas_version and $package_version) {
      $upgrade = true
    } else {
      $upgrade = false
    }
  }

  if $enable_group_policies_real == true {
    $gp_package_ensure = $package_ensure
  } else {
    $gp_package_ensure = 'absent'
  }

  if $users_allow_hiera_merge_real == true {
    $users_allow_entries_real = hiera_array('vas::users_allow_entries')
  } else {
    $users_allow_entries_real = $users_allow_entries
  }

  if $users_deny_hiera_merge_real == true {
    $users_deny_entries_real = hiera_array('vas::users_deny_entries')
  } else {
    $users_deny_entries_real = $users_deny_entries
  }

  package { 'vasclnt':
    ensure => $package_ensure,
  }

  package { 'vasgp':
    ensure => $gp_package_ensure,
  }

  if $::kernel == 'SunOS' {
    file { '/tmp/generic-pkg-response':
      content => 'CLASSES= run\n',
    }

    Package['vasclnt'] {
      source       => $solaris_vasclntpath,
      adminfile    => $solaris_adminpath,
      responsefile => "${solaris_responsepattern}.vasclnt",
      provider     => 'sun',
    }

    Package['vasgp'] {
      source       => $solaris_vasgppath,
      adminfile    => $solaris_adminpath,
      responsefile => "${solaris_responsepattern}.vasgp",
      provider     => 'sun',
    }
  }

  file { 'vas_config':
    ensure  => present,
    path    => $vas_config_path,
    owner   => $vas_config_owner,
    group   => $vas_config_group,
    mode    => $vas_config_mode,
    content => template('vas/vas.conf.erb'),
    require => Package['vasclnt','vasgp'],
  }

  file { 'vas_users_allow':
    ensure  => $vas_users_allow_ensure,
    path    => $vas_users_allow_path,
    owner   => $vas_users_allow_owner,
    group   => $vas_users_allow_group,
    mode    => $vas_users_allow_mode,
    content => template('vas/users.allow.erb'),
    require => Package['vasclnt','vasgp'],
  }

  file { 'vas_users_deny':
    ensure  => $vas_users_deny_ensure,
    path    => $vas_users_deny_path,
    owner   => $vas_users_deny_owner,
    group   => $vas_users_deny_group,
    mode    => $vas_users_deny_mode,
    content => template('vas/users.deny.erb'),
    require => Package['vasclnt','vasgp'],
  }

  file { 'vas_user_override':
    ensure  => $vas_user_override_ensure,
    path    => $vas_user_override_path,
    owner   => $vas_user_override_owner,
    group   => $vas_user_override_group,
    mode    => $vas_user_override_mode,
    content => template('vas/user-override.erb'),
    require => Package['vasclnt','vasgp'],
    before  => Service['vasd'],
  }

  file { 'vas_group_override':
    ensure  => $vas_group_override_ensure,
    path    => $vas_group_override_path,
    owner   => $vas_group_override_owner,
    group   => $vas_group_override_group,
    mode    => $vas_group_override_mode,
    content => template('vas/group-override.erb'),
    require => Package['vasclnt','vasgp'],
    before  => Service['vasd'],
  }

  # optionally create symlinks to vastool binary
  if $symlink_vastool_binary_bool == true {
    # validate params
    validate_absolute_path($symlink_vastool_binary_target)
    validate_absolute_path($vastool_binary)

    file { 'vastool_symlink':
      ensure => link,
      path   => $symlink_vastool_binary_target,
      target => $vastool_binary,
    }
  }

  file { 'join_keytab':
    ensure => $join_keytab_ensure,
    name   => $join_keytab_path,
    source => $join_keytab_source,
    owner  => $join_keytab_owner,
    group  => $join_keytab_group,
    mode   => $join_keytab_mode,
  }

  service { 'vasd':
    ensure  => 'running',
    enable  => true,
    require => Exec['vastool_join'],
  }

  if $sitenameoverride != undef {
    $site_flag = "-s ${sitenameoverride}"
  } else {
    $site_flag = ""
  }

  if $workstation_mode_real == true {
    $workstation_flag = '-w'
  } else {
    $workstation_flag = ''
  }

  if $join_keytab_ensure == 'present' {
    $auth_flags = "-u ${join_username} -k ${join_keytab_path}"
  }
  elsif $join_password != undef {
    $auth_flags = "-u ${join_username} -w ${join_password}"
  } else {
    fail("Either vas::join_password or vas::join_keytab_* must be set.")
  }

  if $user_search_path != undef {
    $user_search_path_flag = "-u ${user_search_path}"
  } else {
    $user_search_path_flag = ""
  }
  if $group_search_path != undef {
    $group_search_path_flag = "-u ${group_search_path}"
  } else {
    $group_search_path_flag = ""
  }
  if $upm_search_path != undef {
    $upm_search_path_flag = "-u ${upm_search_path}"
  } else {
    $upm_search_path_flag = ""
  }

  $once_file = '/etc/opt/quest/vas/puppet_joined'

  exec { 'vastool_join':
    command => "${vastool_binary} ${auth_flags} ${join_debug_flag} join -f ${workstation_flag} -c ${computer_object_container} ${user_search_path_flag} ${group_search_path_flag} ${upm_search_path_flag} -n ${computer_object_name_real} ${site_flag} ${realm} > ${vasjoin_logfile} 2>&1 && touch ${once_file}",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin:/opt/quest/bin',
    timeout => 1800,
    creates => $once_file,
    require => [Package['vasclnt','vasgp'],File['join_keytab']],
  }
}
