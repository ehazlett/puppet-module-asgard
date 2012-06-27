class asgard::package {
  require "asgard::config"

  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  if ! defined(Package["openjdk-6-jre"]) { package { "openjdk-6-jre": ensure => installed, } }
  if ! defined(Package["tomcat7"]) { package { "tomcat7": ensure => installed, } }
  if ! defined(Service["tomcat7"]) { service { "tomcat7": ensure => running, require => Package["tomcat7"], } }

  exec { "asgard::package::get_asgard":
    cwd       => "/tmp",
    command   => "wget ${asgard::params::asgard_war_url} ; mv asgard.war /var/lib/tomcat7/webapps/asgard.war",
    user      => root,
    creates   => "/var/lib/tomcat7/webapps/asgard.war",
    require   => Package["tomcat7"],
  }
  
  file { "asgard::package::tomcat_usr_share":
    ensure  => directory,
    path    => "/usr/share/tomcat7",
    owner   => "tomcat7",
    group   => root,
    require => Package["tomcat7"],
  }

}
