class 389ds::backup (

  $backup_local  = true,

) {

  user { $389ds::params::ds_user:
    shell => '/bin/bash',
  }

  ensure_resource('file', $389ds::params::backup_dir, {'ensure' => 'directory'})

  if $backup_local {
    cron { 'ldap_backup':
      command => $389ds::params::backup_ldap_tool,
      user    => $389ds::params::ds_user,
      hour    => 3,
      minute  => 0
    }

    cron { 'ldif_backup':
      command => "${389ds::params::backup_ldif_tool} -n userRoot",
      user    => $389ds::params::ds_user,
      hour    => 4,
      minute  => 0
    }
  } else {
      notify{"Local LDAP backup for ${fqdn} is not active. (Config in role)":}
  }

  file { $389ds::params::backup_directory:
    ensure => 'directory',
    owner  => $389ds::params::ds_user,
    group  => $389ds::params::ds_group,
    mode   => '0755',
  }

  file { $389ds::params::backup_directorys:
    ensure  => 'directory',
    owner   => $389ds::params::ds_user,
    group   => $389ds::params::ds_group,
    mode    => '0755',
    recurse => true,
    require => File[$389ds::params::backup_directory]
  }

  file { $389ds::params::backup_ldap_tool:
    ensure  => present,
    content => template('389ds/db2bak.erb'),
    owner   => $389ds::params::ds_user,
    group   => $389ds::params::ds_group,
    mode    => '0744',
    require => File[$389ds::params::backup_directorys],
  }

  file { $389ds::params::restore_ldap_tool:
    ensure  => present,
    content => template('389ds/bak2db.erb'),
    owner   => $389ds::params::ds_user,
    group   => $389ds::params::ds_group,
    mode    => '0744',
    require => File[$389ds::params::backup_directorys],
  }

  file { $389ds::params::backup_ldif_tool:
    ensure  => present,
    content => template('389ds/db2ldif.erb'),
    owner   => $389ds::params::ds_user,
    group   => $389ds::params::ds_group,
    mode    => '0744',
    require => File[$389ds::params::backup_directorys],
  }

  file { $389ds::params::restore_ldif_tool:
    ensure  => present,
    content => template('389ds/ldif2db.erb'),
    owner   => $389ds::params::ds_user,
    group   => $389ds::params::ds_group,
    mode    => '0744',
    require => File[$389ds::params::backup_directorys],
  }
}
