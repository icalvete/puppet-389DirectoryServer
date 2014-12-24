class 389ds::config {

  $ldap_host               = $389ds::params::ldap_host
  $ldap_domain             = $389ds::params::ldap_domain
  $ldap_suffix             = $389ds::params::ldap_suffix
  $ldap_admin_user         = $389ds::params::ldap_admin_user
  $ldap_admin_pass         = $389ds::params::ldap_admin_pass
  $ldap_console_admin_pass = $389ds::params::ldap_console_admin_pass
  $ldap_search_user        = $389ds::params::ldap_search_user
  $ldap_search_password    = $389ds::params::ldap_search_password

  file{"${389ds::params::dirsrv_dir}/setup.inf":
    content => template("${module_name}/setup.inf.erb"),
    mode    => '0644',
    owner   => root,
    group   => root,
  }

  exec{'create_dirsrv':
    command => "${389ds::params::setup_ds_path}/${389ds::params::installer} -s -f ${389ds::params::dirsrv_dir}/setup.inf",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    creates => "${389ds::params::dirsrv_dir}/slapd-dir",
    require => File["${389ds::params::dirsrv_dir}/setup.inf"]
  }

  389ds::user{'searcher':
    pass => hiera('ldap_search_pass'),
    ou   => 'ou=Special Users'
  }
}
