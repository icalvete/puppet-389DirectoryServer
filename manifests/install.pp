class 389ds::install {

  case $::operatingsystem {
    /^(CentOS|RedHat)$/:{
    }
    /^(Debian|Ubuntu)$/: {

      realize Package['python-software-properties']

      exec {'add_389ds_repo':
        command => '/usr/bin/add-apt-repository ppa:ubuntu-389-directory-server/ppa',
        require => Package['python-software-properties'],
        notify  => Exec['update_389ds_repo'],
        unless  => '/usr/bin/test -f /etc/apt/sources.list.d/ubuntu-389-directory-server-ppa-precise.list'
      }

      exec {'update_389ds_repo':
        command     => '/usr/bin/apt-get update',
        require     => Exec['add_389ds_repo'],
        refreshonly => true,
      }
    }
    default: {
      fail("Operating System ${::operatingsystem} not supported")
    }
  }

  package {$389ds::params::fonts:
    ensure  => present
  }

  package{ $389ds::params::package:
    ensure  => present
  }
}
