class 389ds::service {

  service{$389ds::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  # This service has status but doesn't work
  service{$389ds::params::admin_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }
}
