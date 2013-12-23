define 389ds::user (

  $user = $name,
  $pass = undef,
  $ou   = 'ou=People'

) {

  if ! $pass {
    fail('389ds::user need pass parameter.')
  }

  $ldap_host               = $389ds::params::ldap_host
  $ldap_domain             = $389ds::params::ldap_domain
  $ldap_suffix             = $389ds::params::ldap_suffix
  $ldap_admin_user         = $389ds::params::ldap_admin_user
  $ldap_admin_pass         = $389ds::params::ldap_admin_pass

  file{"create_user_${name}_ldif":
    path    => "${389ds::params::dirsrv_dir}/${name}.ldif",
    content => template("${module_name}/user.ldif.erb"),
  }

  exec{"create_user_${name}":
    command => "/usr/bin/ldapadd -h ${ldap_host} -D '${ldap_admin_user}' -x -w ${ldap_admin_pass} -f ${389ds::params::dirsrv_dir}/${name}.ldif",
    require => File["create_user_${name}_ldif"],
    unless  => "/usr/bin/ldapsearch -h ${ldap_host} -D 'cn=${user},${ou},${ldap_suffix}' -b '${ldap_suffix}' -x -w ${pass} 'cn=${user}'"
  }
}
