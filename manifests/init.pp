class ds389 (

  $backup_local          = true,
  $cluster               = false,
  $cluster_peer          = undef,
  $replication_id        = undef,
  $backup_directory      = $ds389::params::backup_directory,
  $backup_ldap_directory = $ds389::params::backup_ldap_directory,
  $dirsrv_dir            = $ds389::params::dirsrv_dir,
  $setup_ds_path         = $ds389::params::setup_ds_path,
  $local_retention       = $ds389::params::local_retention,

) inherits ds389::params {

  if $cluster {
    if ! $cluster_peer {
      fail("Cluster node needs a peer. Set cluster_peer param.")
    }
    if ! $replication_id {
      fail("Cluster node needs replication_id param.")
    }
  }

  anchor{'ds389::begin':
    before => Class['ds389::install'],
  }

  class {'ds389::install':
    require => Anchor['ds389::begin'],
    before  => Class['ds389::config'],
  }

  class {'ds389::config':
    require => Class['ds389::install'],
    before  => Class['ds389::service'],
  }

  class {'ds389::service':
    require => Class['ds389::config'],
    before  => Class['ds389::cluster'],
  }

  class {'ds389::cluster':
    require        => Class['ds389::service'],
    before         => Class['ds389::backup'],
    cluster        => $cluster,
    cluster_peer   => $cluster_peer,
    replication_id => $replication_id
  }

  class {'ds389::backup':
    require       => Class['ds389::cluster'],
    before        => Anchor['ds389::end'],
    backup_local  => $backup_local,
  }

  anchor{'ds389::end':
    require => Class['ds389::backup'],
  }
}
