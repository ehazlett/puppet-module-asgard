# Class: asgard
#
# This module manages asgard
#
# Parameters:
#   n/a
# Actions:
#   Installs and configures Asgard
# Requires:
#   n/a
#
# Sample usage:
#
#  include asgard
#
class asgard inherits asgard::params {
  class { 'asgard::config': }
  class { 'asgard::package':
    require => Class['asgard::config'],
  }
}
