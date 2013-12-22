class ds389::config {

  $ldap_domain          = hiera('ldap_domain')
  $ldap_suffix          = hiera('ldap_suffix')
  $ldap_admin_user      = hiera('ldap_admin_user')
  $ldap_admin_password  = hiera('ldap_admin_password')
  $ldap_search_user     = hiera('ldap_search_user')
  $ldap_search_password = hiera('ldap_search_password')

  file{"${ds389::params::dirsrv_dir}/setup.inf":
    content => template("${module_name}/setup.inf.erb"),
    mode    => '0644',
    owner   => root,
    group   => root,
  }
  exec{"create_dirsrv":
    command => "${ds389::params::setup_ds_path}/${ds389::params::installer} -s -f ${ds389::params::dirsrv_dir}/setup.inf",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    creates => "${ds389::params::dirsrv_dir}/slapd-dir",
    require => File["${ds389::params::dirsrv_dir}/setup.inf"]
  }
  file{'create_nonprivilege_user_ldif':
    path    => "${ds389::params::dirsrv_dir}/searcher.ldif",
    content => template("${module_name}/searcher.ldif.erb"),
  }
  exec{'creat_nonprivilege_user':
    command => "/usr/bin/ldapadd -D '${ldap_admin_user}' -x -w ${ldap_admin_password} -f ${ds389::params::dirsrv_dir}/searcher.ldif",
    require => [Exec['create_dirsrv'], File['create_nonprivilege_user_ldif']],
    unless  => "/usr/bin/ldapsearch -D 'cn=${ldap_search_user},${ldap_suffix}' -b '${ldap_suffix}' -x -w ${ldap_search_password} 'cn=${ldap_search_user}'"
  }
}
