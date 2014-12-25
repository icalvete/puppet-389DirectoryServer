class 389ds::install {

  package {$389ds::params::fonts:
    ensure  => present
  }

  package{ $389ds::params::package:
    ensure  => present
  }
}
