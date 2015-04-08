# == Class: cloudwatchlogs
#
# Configure AWS Cloudwatch Logs on Amazon Linux instances.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*logs*]
#   A hash of arrays containg the 'name' & the 'path' of the log file(s) of the 
#   log file(s) to be sent to Cloudwatch Logs.
#
# [*region*]
#   The region your EC2 instance is running in.
#
# [*aws_access_key_id*]
#   The Access Key ID from the IAM user that has access to Cloudwatch Logs.
#
# [*aws_secret_access_key*]
#   The Secret Access Key from the IAM user that has access to Cloudwatch Logs.
#
# === Examples
#
#  class { 'cloudwatchlogs':
#    region                => 'eu-west-1',
#    aws_access_key_id     => 'AKIAIOSFODNN7EXAMPLE',
#    aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
#  }
#
# === Authors
#
# Danny Roberts <danny.roberts@reconnix.com>
# Russ McKendrick <russ.mckendrick@reconnix.com>
#
# === Copyright
#
# Copyright 2015 Danny Roberts & Russ McKendrick
#
class cloudwatchlogs {

  # Check the OS is Amazon Linux
  case $::operatingsystem {
    'Amazon': {
      $logs = [
        { name => 'Messages', path => '/var/log/messages', },
        { name => 'Secure', path => '/var/log/secure', },
      ]
    }
    default: { fail("The ${module_name} module is not supported on 
      ${::osfamily}/${::operatingsystem}.") }
  }
  
  # Set some default variables
  $region                = undef
  $aws_access_key_id     = undef
  $aws_secret_access_key = undef
  
  # Validate variables using puppet/stdlib
  validate_hash($logs)
  validate_string($region)
  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key)

  # Set some File type defaults
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['awslogs'],
    before  => Service['awslogs'],
    notify  => Service['awslogs'],
  }
  
  # Install the cloudwatchlogs package
  package { 'awslogs':
    ensure => 'installed',
  }
  
  # Manage the cloudwatchlogs config files
  file { '/etc/awslogs/awslogs.conf':
    ensure  => 'file',
    content => template('cloudwatchlogs/awslogs.conf.erb'),
  }
  file { '/etc/awslogs/awscli.conf':
    ensure  => 'file',
    content => template('cloudwatchlogs/awscli.conf.erb'),
  }
  
  # Start the clouwatchlogs service
  service { 'awslogs':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  
}
