class 389ds (

  $ssl                   = true,
  $backup_local          = true,
  $cluster               = false,
  $cluster_peer          = undef,
  $replication_id        = undef,
  $backup_directory      = $389ds::params::backup_directory,
  $backup_ldap_directory = $389ds::params::backup_ldap_directory,
  $dirsrv_dir            = $389ds::params::dirsrv_dir,
  $setup_ds_path         = $389ds::params::setup_ds_path,
  $local_retention       = $389ds::params::local_retention,

) inherits 389ds::params {

  if $cluster {
    if ! $cluster_peer {
      fail('Cluster node needs a peer. Set cluster_peer param.')
    }
    if ! $replication_id {
      fail('Cluster node needs replication_id param.')
    }
  }

  anchor{'389ds::begin':
    before => Class['389ds::install'],
  }

  class {'389ds::install':
    require => Anchor['389ds::begin'],
  }

  class {'389ds::config':
    notify => Class['389ds::service'],
  }

  class {'389ds::service':
    require => Class['389ds::config'],
  }

  class {'389ds::cluster':
    require        => Class['389ds::service'],
    before         => Class['389ds::backup'],
    cluster        => $cluster,
    cluster_peer   => $cluster_peer,
    replication_id => $replication_id
  }

  class {'389ds::backup':
    require      => Class['389ds::cluster'],
    before       => Class['389ds::postconfig'],
    backup_local => $backup_local,
  }

  class {'389ds::postconfig':
    require => Class['389ds::backup'],
    before  => Anchor['389ds::end'],
  }

  anchor{'389ds::end':
    require => Class['389ds::backup'],
  }
}
