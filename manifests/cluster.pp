class ds389::cluster (

  $cluster             = false,
  $cluster_peer        = undef,
  $replication_id      = undef,
  $ldap_admin_user     = hiera('ldap_admin_user'),
  $ldap_admin_password = hiera('ldap_admin_password'),
  $ldap_suffix         = hiera('ldap_suffix'),
  $config_ha_file      = '/tmp/config_ha.ldif',
  $enable_ha_file      = '/tmp/enable_ha.ldif'

) {

  if $cluster {
    if ! $cluster_peer {
      fail('Cluster node needs a peer. Set cluster_peer param.')
    }
    if ! $replication_id {
      fail('Cluster node needs replication_id param.')
    }

    file{$config_ha_file:
      ensure  => file,
      content => template("${module_name}/config_ha.ldif.erb"),
      owner   => root,
      group   => root,
      mode    => '0640'
    }

    file{$enable_ha_file:
      ensure  => file,
      content => template("${module_name}/enable_ha.ldif.erb"),
      owner   => root,
      group   => root,
      mode    => '0640'
    }

    exec {'config_ds389_ha':
      command => "/usr/bin/ldapadd -h localhost -p 389 -D '${ldap_admin_user}' -w ${ldap_admin_password} -f ${config_ha_file}",
      user    => 'root',
      unless  => "/usr/bin/ldapsearch -h localhost -p 389 -D '${ldap_admin_user}' -w ${ldap_admin_password} -s sub -b cn=config '(cn=replication manager)' | grep numEntries",
      require => File[$config_ha_file],
      before  => Exec['enable_ds389_ha']
    }

    exec {'enable_ds389_ha':
      command => "/usr/bin/ldapadd -h localhost -p 389 -D '${ldap_admin_user}' -w ${ldap_admin_password} -f ${enable_ha_file}",
      user    => 'root',
      onlyif  => "/usr/bin/ldapsearch -h ${cluster_peer} -p 389 -D '${ldap_admin_user}' -w ${ldap_admin_password} -s sub -b cn=config '(cn=replication manager)' | grep numEntries",
      require => File[$enable_ha_file]
    }
  }
}
