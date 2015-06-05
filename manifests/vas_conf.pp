define vas::vas_conf_setting  (
  $ensure  = present,
  $path    = '/tmp/vas.conf-puppet',
  $setting = $name,
  $section,
  $value,
) {

  ini_setting { "${section}-${setting}":
    ensure  => $ensure,
    path    => $path,
    section => $section,
    setting => $setting,
    value   => $value,
  }
}


#[domain_realm]
# esekilx1620.rnd.ericsson.se = ERICSSON.SE

#[vasd]
# update-interval = 600
# upm-search-path = ou=ki,ou=se,ou=users,ou=eunix,dc=eemea,dc=ericsson,dc=se
# workstation-mode = false
# auto-ticket-renew-interval = 32400
# lazy-cache-update-interval = 10
# preload-nested-memberships = false

class vas::config (
  $vas_conf_path               = '/etc/opt/quest/vas/vas.conf',
  $vas_conf_owner              = 'root',
  $vas_conf_group              = 'root',
  $vas_conf_mode               = '0644',
  $domain_realm_options        = undef,
  $libdefaults_options         = undef,
  $libvas_options              = undef,
  $pam_vas_options             = undef,
  $vasypd_options              = undef,
  $vasd_options                = undef,
  $nss_vas_options             = undef,
  $vas_auth_options            = undef,
  $hiera_merge_options         = true,
  $default_libdefaults_options = $vas::params::default_libdefault_options,
  $default_libvas_options      = $vas::params::default_libvas_options,
  $default_pam_vas_options     = $vas::params::default_pam_vas_options,
  $default_libvas_options      = $vas::params::default_libvas_options,
  $default_vasypd_options      = $vas::params::default_vasypd_options,
  $default_vasd_options        = $vas::params::default_vasd_options,
  $default_nss_vas_options     = $vas::params::default_nss_vas_options,
  $default_vas_auth_options    = $vas::params::default_vas_auth_options,
  $default_options     = {
                          },
                          'libvas'                => {
                            'auth-helper-timeout' => '10',
                            'use-tcp-only'        => 'true',
                          },
                        },
) {

  $_default

  $vas_conf_ini_defaults = { 'path' => '/tmp/vas.conf-puppet', 'ensure' => 'present' }

  $domain_realm_defaults = { "section" => "domain_realm" }
  $domain_realm = {
    "esekilx1620.rnd.ericsson.se" => { "setting" => "esekilx1620.rnd.ericsson.se", "value" => "ERICSSON.SE" },
  }

  $vasd_ini_defaults = { "section" => 'vasd' }
  $vasd_ini = {
    'update-interval'  => { 'value'  => '600' },
    'workstation-mode' => { 'value' => 'false' },
  }
  $vasd_ini_extra = {
    'update-interval'  => { 'value'  => '300' },
  }

  $vasd_ini_real = merge($vasd_ini, $vasd_ini_extra)
  create_resources(vas::vas_conf_setting, $vasd_ini_real, $vasd_ini_defaults)

#create_resources(ini_setting, $domain_realm, merge($vas_conf_ini_defaults, $domain_realm_defaults))
#create_resources(ini_setting, $vasd_ini_real, merge($vas_conf_ini_defaults, $vasd_ini_defaults))

#ini_setting { "vas.conf-vasd":
#  ensure  => present,
#  path    => '/tmp/vas.conf-puppet',
#  section => 'bar',
#  setting => 'baz',
#  value   => 'quux',
#}

}
#  $vas_conf_client_addrs                                = 'UNSET',
#  $vas_conf_full_update_interval                        = 'UNSET',
#  $vas_conf_disabled_user_pwhash                        = undef,
#  $vas_conf_locked_out_pwhash                           = undef,
#  $vas_conf_preload_nested_memberships                  = 'UNSET',
#  $vas_conf_update_process                              = '/opt/quest/libexec/vas/mapupdate_2307',
#  $vas_conf_upm_computerou_attr                         = 'department',
#  $vas_conf_vasd_update_interval                        = '600',
#  $vas_conf_vasd_auto_ticket_renew_interval             = '32400',
#  $vas_conf_vasd_lazy_cache_update_interval             = '10',
#  $vas_conf_vasd_timesync_interval                      = 'USE_DEFAULTS',
#  $vas_conf_vasd_cross_domain_user_groups_member_search = 'UNSET',
#  $vas_conf_vasd_password_change_script                 = 'UNSET',
#  $vas_conf_vasd_password_change_script_timelimit       = 'UNSET',
#  $vas_conf_vasd_workstation_mode                       = false,
#  $vas_conf_vasd_workstation_mode_users_preload         = 'UNSET',
#  $vas_conf_vasd_workstation_mode_group_do_member       = false,
#  $vas_conf_vasd_workstation_mode_groups_skip_update    = false,
#  $vas_conf_vasd_ws_resolve_uid                         = false,
#  $vas_conf_vasd_deluser_check_timelimit                = 'UNSET',
#  $vas_conf_vasd_delusercheck_interval                  = 'UNSET',
#  $vas_conf_vasd_delusercheck_script                    = 'UNSET',
#  $vas_conf_prompt_vas_ad_pw                            = '"Enter Windows password: "',
#  $vas_conf_pam_vas_prompt_ad_lockout_msg               = 'UNSET',
#  $vas_conf_libdefaults_forwardable                     = true,
#  $vas_conf_vas_auth_uid_check_limit                    = 'UNSET',
#  $vas_conf_libvas_vascache_ipc_timeout                 = 15,
#  $vas_conf_libvas_use_server_referrals                 = true,
#  $vas_conf_libvas_auth_helper_timeout                  = 10,
#  $vas_conf_libvas_mscldap_timeout                      = 1,
#  $vas_conf_libvas_site_only_servers                    = false,
#  $vas_conf_libvas_use_dns_srv                          = true,
#  $vas_conf_libvas_use_tcp_only                         = true,
#) {

#  # validate params
#  validate_re($vas_conf_vasd_auto_ticket_renew_interval, '^\d+$', "vas::vas_conf_vasd_auto_ticket_renew_interval must be an integer. Detected value is <${vas_conf_vasd_auto_ticket_renew_interval}>.")
#  validate_re($vas_conf_vasd_update_interval, '^\d+$', "vas::vas_conf_vasd_update_interval must be an integer. Detected value is <${vas_conf_vasd_update_interval}>.")
#  if $vas_conf_vasd_deluser_check_timelimit != 'UNSET' {
#    validate_re($vas_conf_vasd_deluser_check_timelimit, '^\d+$', "vas::vas_conf_vasd_deluser_check_timelimit must be an integer. Detected value is <${vas_conf_vasd_deluser_check_timelimit}>.")
#  }
#  if $vas_conf_vasd_delusercheck_interval != 'UNSET' {
#    validate_re($vas_conf_vasd_delusercheck_interval, '^\d+$', "vas::vas_conf_vasd_delusercheck_interval must be an integer. Detected value is <${vas_conf_vasd_delusercheck_interval}>.")
#  }
#  validate_re($vas_conf_libvas_vascache_ipc_timeout, '^\d+$', "vas::vas_conf_libvas_vascache_ipc_timeout must be an integer. Detected value is <${vas_conf_libvas_vascache_ipc_timeout}>.")
#  validate_re($vas_conf_libvas_auth_helper_timeout, '^\d+$', "vas::vas_conf_libvas_auth_helper_timeout must be an integer. Detected value is <${vas_conf_libvas_auth_helper_timeout}>.")
#  validate_string($vas_conf_prompt_vas_ad_pw)

#  if $vas_conf_disabled_user_pwhash != undef {
#    validate_string($vas_conf_disabled_user_pwhash)
#  }
#
#  if $vas_conf_locked_out_pwhash != undef {
#    validate_string($vas_conf_locked_out_pwhash)
#  }


#  if $vas_conf_vasd_delusercheck_script != 'UNSET' {
#    validate_absolute_path($vas_conf_vasd_delusercheck_script)
#  }
#  if is_string($vas_conf_libdefaults_forwardable) {
#    $vas_conf_libdefaults_forwardable_real = str2bool($vas_conf_libdefaults_forwardable)
#  } else {
#    $vas_conf_libdefaults_forwardable_real = $vas_conf_libdefaults_forwardable
#  }

#  if is_string($vas_conf_libvas_use_server_referrals) {
#    $vas_conf_libvas_use_server_referrals_real = str2bool($vas_conf_libvas_use_server_referrals)
#  } else {
#    $vas_conf_libvas_use_server_referrals_real = $vas_conf_libvas_use_server_referrals
#  }
#
#  if is_string($vas_conf_libvas_use_dns_srv) {
#    $vas_conf_libvas_use_dns_srv_real = str2bool($vas_conf_libvas_use_dns_srv)
#  } else {
#    $vas_conf_libvas_use_dns_srv_real = $vas_conf_libvas_use_dns_srv
#  }
#
#  if is_string($vas_conf_libvas_use_tcp_only) {
#    $vas_conf_libvas_use_tcp_only_real = str2bool($vas_conf_libvas_use_tcp_only)
#  } else {
#    $vas_conf_libvas_use_tcp_only_real = $vas_conf_libvas_use_tcp_only
#  }
#
#  if is_string($vas_conf_libvas_site_only_servers) {
#    $vas_conf_libvas_site_only_servers_real = str2bool($vas_conf_libvas_site_only_servers)
#  } else {
#    $vas_conf_libvas_site_only_servers_real = $vas_conf_libvas_site_only_servers
#  }
#
#
#  if is_string($vas_conf_vasd_workstation_mode_group_do_member) {
#    $vas_conf_vasd_workstation_mode_group_do_member_real = str2bool($vas_conf_vasd_workstation_mode_group_do_member)
#  } else {
#    $vas_conf_vasd_workstation_mode_group_do_member_real = $vas_conf_vasd_workstation_mode_group_do_member
#  }
#
#  if is_string($vas_conf_vasd_workstation_mode_groups_skip_update) {
#    $vas_conf_vasd_workstation_mode_groups_skip_update_real = str2bool($vas_conf_vasd_workstation_mode_groups_skip_update)
#  } else {
#    $vas_conf_vasd_workstation_mode_groups_skip_update_real = $vas_conf_vasd_workstation_mode_groups_skip_update
#  }
#  if is_string($vas_conf_vasd_ws_resolve_uid) {
#    $vas_conf_vasd_ws_resolve_uid_real = str2bool($vas_conf_vasd_ws_resolve_uid)
#  } else {
#    $vas_conf_vasd_ws_resolve_uid_real = $vas_conf_vasd_ws_resolve_uid
#  }
#  case $::virtual {
#    'zone': {
#      $default_vas_conf_vasd_timesync_interval = 0
#    }
#    default: {
#      $default_vas_conf_vasd_timesync_interval = 'UNSET'
#    }
#  }

#  # Use defaults if a value was not specified in Hiera.
#  if $vas_conf_vasd_timesync_interval == 'USE_DEFAULTS' {
#    $vas_conf_vasd_timesync_interval_real = $default_vas_conf_vasd_timesync_interval
#  } else {
#    $vas_conf_vasd_timesync_interval_real = $vas_conf_vasd_timesync_interval
#  }

