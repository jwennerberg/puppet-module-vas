#
class vas::params() {

  $default_libdefaults_options = {
    'default_keytab_name'  => '/etc/opt/quest/vas/host.keytab',
    'default_etypes_des'   => 'des-cbc-crc des-cbc-md5',
    'default_etypes'       => 'arcfour-hmac-md5',
    'default_tkt_enctypes' => 'arcfour-hmac-md5 des-cbc-md5 des-cbc-crc',
    'forwardable'          => 'true',
    'renew_lifetime'       => '604800',
    'ticket_lifetime'      => '36000',
  }
  $default_libvas_options = {
    'use-tcp-only'        => 'true',
    'use-dns-srv'         => 'true',
    'auth-helper-timeout' => '10',
    'mscldap-timeout'     => '1',
  }
  $default_vasypd_options = {
    'update-interval' => '1800',
    'update-process'  => '/opt/quest/libexec/vas/mapupdate_2307',
  }
  $default_vasd_options = {
    'update-interval'            => '600',
    'auto-ticket-renew-interval' => '32400',
    'lazy-cache-update-interval' => '10',
    'preload-nested-memberships' => 'false',
  }
  $default_nss_vas_options = {
    'group-update-mode' => 'none',
    'root-update-mode'  => 'none',
  }
  $default_pam_vas_options = { }
  $default_vas_auth_options = { }
}
