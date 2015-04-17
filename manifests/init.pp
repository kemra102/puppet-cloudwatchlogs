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
class cloudwatchlogs (

  $logs                  = $::cloudwatchlogs::params::logs,
  $region                = $::cloudwatchlogs::params::region,
  $aws_access_key_id     = $::cloudwatchlogs::params::aws_access_key_id,
  $aws_secret_access_key = $::cloudwatchlogs::params::aws_secret_access_key,

) inherits cloudwatchlogs::params {

  validate_hash($logs)
  validate_string($region)
  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key)

  case $::operatingsystem {
    'Amazon': {
      package { 'awslogs':
        ensure => 'present',
        before => [
          File['/etc/awslogs/awslogs.conf'],
          File['/etc/awslogs/awscli.conf'],
        ],
      }
      file { '/etc/awslogs/awslogs.conf':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        content => template('cloudwatchlogs/awslogs.conf.erb'),
      }
      file { '/etc/awslogs/awscli.conf':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        content => template('cloudwatchlogs/awscli.conf.erb'),
      }
      service { 'awslogs':
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => [
          File['/etc/awslogs/awslogs.conf'],
          File['/etc/awslogs/awscli.conf'],
        ],
      }
    }
    /^(Ubuntu|CentOS|RedHat)$/: {
      # We need wget to fetch the installation script
      package { 'wget':
        ensure => 'present',
      }
      # Grab the installation script
      exec { 'cloudwatchlogs-wget':
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        command => 'wget -O /usr/local/src/awslogs-agent-setup.py https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py',
        unless  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
      }
      # Create the /etc/awslogs directory manually
      file { '/etc/awslogs':
        ensure => 'directory',
        mode   => '0755',
        before => [
          File['/etc/awslogs/awslogs.conf'],
          File['/etc/awslogs/awscli.conf'],
        ],
      }
      # Populate the config files
      file { '/etc/awslogs/awslogs.conf':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        content => template('cloudwatchlogs/awslogs.conf.erb'),
      }
      file { '/etc/awslogs/awscli.conf':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        content => template('cloudwatchlogs/awscli.conf.erb'),
      }
      # Install cloudwatchlogs
      exec { 'cloudwatchlogs-install':
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
        onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
        unless  => '[ -f /var/awslogs/etc/awslogs.conf ]',
        require => [
          File['/etc/awslogs/awslogs.conf'],
          File['/etc/awslogs/awscli.conf'],
        ],
        before  => Service['awslogs'],
      }
      service { 'awslogs':
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => [
          File['/etc/awslogs/awslogs.conf'],
          File['/etc/awslogs/awscli.conf'],
        ],
      }
    }
  }

}
