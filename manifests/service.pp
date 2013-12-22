class ds389::service {

  service{$ds389::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  # This service has status but doesn't work
  service{$ds389::params::admin_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }
}
