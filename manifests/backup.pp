class ds389::backup (

  $backup_local  = true,

) {

  user { $ds389::params::ds_user:
    shell => '/bin/bash',
  }

  if $backup_local {
    cron { 'ldap_backup':
      command => $ds389::params::backup_ldap_tool,
      user    => $ds389::params::ds_user,
      hour    => 3,
      minute  => 0
    }

    cron { 'ldif_backup':
      command => "${ds389::params::backup_ldif_tool} -n userRoot",
      user    => $ds389::params::ds_user,
      hour    => 4,
      minute  => 0
    }
  } else {
      notify{"Local LDAP backup for ${fqdn} is not active. (Config in role)":}
  }

  file { $ds389::params::backup_directory:
    ensure  => 'directory',
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0755',
  }

  file { $ds389::params::backup_directorys:
    ensure  => 'directory',
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0755',
    recurse => true,
    require => File[$ds389::params::backup_directory]
  }

  file { $ds389::params::backup_ldap_tool:
    ensure  => present,
    content => template('ds389/db2bak.erb'),
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0744',
    require => File[$ds389::params::backup_directorys],
  }

  file { $ds389::params::restore_ldap_tool:
    ensure  => present,
    content => template('ds389/bak2db.erb'),
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0744',
    require => File[$ds389::params::backup_directorys],
  }

  file { $ds389::params::backup_ldif_tool:
    ensure  => present,
    content => template('ds389/db2ldif.erb'),
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0744',
    require => File[$ds389::params::backup_directorys],
  }

  file { $ds389::params::restore_ldif_tool:
    ensure  => present,
    content => template('ds389/ldif2db.erb'),
    owner   => $ds389::params::ds_user,
    group   => $ds389::params::ds_group,
    mode    => '0744',
    require => File[$ds389::params::backup_directorys],
  }
}
