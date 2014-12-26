class 389ds::postconfig {

  if $389ds::ssl {
    exec{ 'enable_ssl_restart':
      command  => "/etc/init.d/dirsrv restart",
      user     => 'root',
      provider => 'shell',
      unless   => '/bin/netstat -natp | /bin/grep 636',
    }

    exec{ 'enable_ssl_admin_restart':
      command  => "/etc/init.d/dirsrv-admin restart",
      user     => 'root',
      provider => 'shell',
      unless   => '/bin/echo "" | openssl s_client -connect localhost:9830 | /bin/grep "Server certificate"',
    }
  }
}
