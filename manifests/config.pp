class asgard::config inherits asgard::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  exec { "asgard::config::update_apt":
    command => "apt-get update",
    user    => root,
  }
}
