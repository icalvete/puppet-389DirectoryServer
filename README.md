#puppet-389DirectoryServer

Puppet manifest to install and configure 389DirectoryServer

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-389DirectoryServer.png)](http://travis-ci.org/icalvete/puppet-389DirectoryServer)

See [389 Directory Server site](http://directory.fedoraproject.org/wiki/Main_Page)

* [hiera](http://docs.puppetlabs.com/hiera/1/index.html)

## Requisites

Only tested in ubuntu 14.04 LTS (trusty) for osfamily = Debian

(Old version supports 13.10 (Saucy) using a ppa repo but now this makes no sense to me)

##Example:


```puppet
node /ubuntu01.smartpurposes.net/ inherits test_defaults {

  class {'roles::ldap_server':
    cluster        => true,
    cluster_peer   => 'ubuntu02.smartpurposes.net'
    replication_id => '1'
  }
}

node /ubuntu02.smartpurposes.net/ inherits test_defaults {
  
  class {'roles::ldap_server':
    cluster        => true,
    cluster_peer   => 'ubuntu01.smartpurposes.net'
    replication_id => '2'
  }
}

class roles::ldap_server (

  $backup_local   = true,
  $cluster        = false,
  $cluster_peer   = undef,
  $replication_id = undef

) inherits roles {

  if $cluster {
    if ! $cluster_peer {
      fail('Cluster node needs a peer. Set cluster_peer param.')
    }
    if ! $replication_id {
      fail('Cluster node needs replication_id param.')
    }
  }

  class {'ds389':
    backup_local   => $backup_local,
    cluster        => $cluster,
    cluster_peer   => $cluster_peer,
    replication_id => $replication_id
}

```

##Authors:

Israel Calvete Talavera <icalvete@gmail.com>
