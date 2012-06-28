class asgard::package {
  require "asgard::config"

  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # jdk
  exec { "asgard::package::get_jdk":
    cwd       => "/tmp",
    command   => "wget --quiet --no-cookies --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F' '${asgard::params::jdk_url}' -O jdk.bin ; chmod +x jdk.bin",
    timeout   => 900,
    creates   => "/opt/java",
    notify    => Exec["asgard::package::extract_jdk"],
  }
  exec { "asgard::package::extract_jdk":
    cwd         => "/opt",
    command     => "yes | /tmp/jdk.bin ; ln -sf /opt/jdk* /opt/java",
    refreshonly => true,
    notify      => Exec["asgard::package::configure_jdk"],
  }
  exec { "asgard::package::configure_jdk":
    cwd         => "/opt",
    command     => "update-alternatives --install '/usr/bin/java' 'java' '/opt/java/bin/java' 1 ; update-alternatives --install '/usr/bin/javac' 'javac' '/opt/java/bin/javac' 1",
    refreshonly => true,
    notify      => Exec["asgard::package::configure_profile"],
  }
  exec { "asgard::package::configure_profile":
    command     => "echo 'export JAVA_HOME=/opt/java' >> /etc/profile",
    refreshonly => true,
  }
  # tomcat
  exec { "asgard::package::get_tomcat":
    cwd         => "/tmp",
    command     => "wget --quiet --no-cookies '${asgard::params::tomcat_url}' -O tomcat.tar.gz",
    creates     => "/opt/tomcat",
    notify      => Exec["asgard::package::install_tomcat"],
  }
  exec { "asgard::package::install_tomcat":
    cwd         => "/opt",
    command     => "tar zxf /tmp/tomcat.tar.gz ; mv apache-tomcat* tomcat ; rm -rf tomcat/webapps/*",
    require     => Exec["asgard::package::get_tomcat"],
    refreshonly => true,
  }
  # asgard
  exec { "asgard::package::get_asgard":
    cwd       => "/tmp",
    command   => "wget --quiet ${asgard::params::asgard_war_url} ; mv asgard.war /opt/tomcat/webapps/ROOT.war",
    user      => root,
    creates   => "/opt/tomcat/webapps/ROOT",
    require   => Exec["asgard::package::install_tomcat"],
  }
}
