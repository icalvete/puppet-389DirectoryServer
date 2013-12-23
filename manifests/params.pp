class 389ds::params {

  $ldap_host               = hiera('ldap_host')
  $ldap_domain             = hiera('ldap_domain')
  $ldap_suffix             = hiera('ldap_suffix')
  $ldap_admin_user         = hiera('ldap_admin_user')
  $ldap_admin_pass         = hiera('ldap_admin_pass')
  $ldap_console_admin_pass = hiera('ldap_console_admin_pass')
  $ldap_search_user        = hiera('ldap_search_user')
  $ldap_search_pass        = hiera('ldap_search_pass')

  $dirsrv_dir              = '/etc/dirsrv'
  $dirsrv_dir_lib          = '/var/lib/dirsrv'
  $setup_ds_path           = '/usr/sbin'
  $service_name            = 'dirsrv'
  $admin_service_name      = 'dirsrv-admin'

  $backup_directory        = '/srv/ldap'
  $backup_directorys       = "${backup_directory}/bin"

  $backup_ldap_tool        = "${backup_directory}/${backup_ldap_directory}/bin/db2bak"
  $restore_ldap_tool       = "${backup_directory}/${backup_ldap_directory}/bin/bak2db"
  $backup_ldif_tool        = "${backup_directory}/${backup_ldap_directory}/bin/db2ldif"
  $restore_ldif_tool       = "${backup_directory}/${backup_ldap_directory}/bin/ldif2db"

  $local_retention         = '3'

  case $::operatingsystem {
    /^(CentOS|RedHat)$/:{
      $installer  = 'setup-ds-admin.pl'
      $ds_user    = 'nobody'
      $ds_group   = 'nobody'

      $package    = [
                      '389-ds',
                      '389-admin',
                      '389-admin-console',
                      '389-admin-console-doc',
                      '389-adminutil',
                      '389-ds-console',
                      '389-ds-console-doc',
                      '389-dsgw',
                      '389-console',
                      'idm-console-framework',
                      'ldap-utils'
                    ]
      $fonts      = [
                      'xorg-x11-fonts-Type1',
                      'xorg-x11-fonts-75dpi',
                      'ghostscript-fonts',
                      'urw-fonts',
                      'xorg-x11-fonts-100dpi',
                      'xorg-x11-fonts-ISO8859-15-100dpi',
                      'xorg-x11-fonts-ISO8859-1-100dpi',
                      'xorg-x11-fonts-ISO8859-1-75dpi',
                      'xorg-x11-fonts-ISO8859-15-75dpi',
                      'liberation-fonts-common',
                      'liberation-serif-fonts',
                      'liberation-sans-fonts',
                      'liberation-mono-fonts',
                      'dejavu-lgc-sans-fonts',
                      'dejavu-lgc-sans-mono-fonts',
                      'dejavu-lgc-serif-fonts'
                    ]
    }
    /^(Debian|Ubuntu)$/: {
      $installer = 'setup-ds-admin'
      $ds_user   = 'dirsrv'
      $ds_group  = 'dirsrv'

      $package   = [
                    '389-ds',
                    '389-admin',
                    '389-ds-base',
                    '389-ds-console',
                    'ldap-utils'
                    ]
      $fonts     = [
                    'xfonts-75dpi',
                    'xfonts-100dpi',
                    'ttf-dejavu'
                    ]
    }
    default: {
      fail("Operating System ${::operatingsystem} not supported")
    }
  }
}
