# == Class: cloudwatchlogs
#
# Configure AWS Cloudwatch Logs on Amazon Linux instances.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*state_file*]
#   State file for the awslogs agent.
#
# [*logs*]
#   A hash of arrays containg the 'name' & the 'path' of the log file(s) of the
#   log file(s) to be sent to Cloudwatch Logs.
#
# [*datetime_formats*]
#   A hash of arrays containg the 'name' & the 'datetime_format' of the log file(s) of the
#   log file(s) to be sent to Cloudwatch Logs.
#
# [*region*]
#   The region your EC2 instance is running in.
#
# [*streamname*]
#   The name of the stream in CW Logs. Defaults to instance-id.
#
# [*aws_access_key_id*]
#   The Access Key ID from the IAM user that has access to Cloudwatch Logs.
#
# [*aws_secret_access_key*]
#   The Secret Access Key from the IAM user that has access to Cloudwatch Logs.
#
# [*streamname*]
#   Specifies the destination log stream.
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

  $state_file            = $::cloudwatchlogs::params::state_file,
  $logs                  = $::cloudwatchlogs::params::logs,
  $datetime_formats      = $::cloudwatchlogs::params::datetime_formats,
  $region                = $::cloudwatchlogs::params::region,
  $aws_access_key_id     = $::cloudwatchlogs::params::aws_access_key_id,
  $aws_secret_access_key = $::cloudwatchlogs::params::aws_secret_access_key,
  $streamname            = $::cloudwatchlogs::params::streamname,

) inherits cloudwatchlogs::params {

  validate_absolute_path($state_file)
  validate_array($logs)
  if $region {
    validate_string($region)
  }
  if $aws_access_key_id {
    validate_string($aws_access_key_id)
  }
  if $aws_secret_access_key {
    validate_string($aws_secret_access_key)
  }
  validate_string($streamname)

  case $::operatingsystem {
    'Amazon': {
      package { 'awslogs':
        ensure => 'present',
        before => File['/etc/awslogs/awslogs.conf'],
      }

      file { '/etc/awslogs/awslogs.conf':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('cloudwatchlogs/awslogs.conf.erb'),
      }

      if $region and $aws_access_key_id and $aws_secret_access_key {
        file { '/etc/awslogs/awscli.conf':
          ensure  => 'file',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          require => Package['awslogs'],
          notify  => Service['awslogs'],
          content => template('cloudwatchlogs/awscli.conf.erb'),
        }
      }

      service { 'awslogs':
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/etc/awslogs/awslogs.conf'],
      }
    }
    /^(Ubuntu|CentOS|RedHat)$/: {
      if ! defined(Package['wget']) {
        package { 'wget':
          ensure => 'present',
        }
      }
      exec { 'cloudwatchlogs-wget':
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        command => 'wget -O /usr/local/src/awslogs-agent-setup.py https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py',
        unless  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
      }
      file { '/etc/awslogs':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      file { '/var/awslogs':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      file { '/var/awslogs/etc':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File['/var/awslogs'],
        before  => [
          File['/var/awslogs/etc/awslogs.conf'],
        ],
      }
      file { '/etc/awslogs/awslogs.conf':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('cloudwatchlogs/awslogs.conf.erb'),
        require => File['/etc/awslogs'],
      }
      file { '/var/awslogs/etc/awslogs.conf':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('cloudwatchlogs/awslogs.conf.erb'),
      }
      if $region and $aws_access_key_id and $aws_secret_access_key {
        file { '/var/awslogs/etc/awscli.conf':
          ensure  => 'file',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          require => File['/var/awslogs/etc'],
          notify  => Service['awslogs'],
          content => template('cloudwatchlogs/awscli.conf.erb'),
        }
      }
      if ($region == undef) {
        fail("${region} must be defined on ${::operatingsystem}")
      } else {
        exec { 'cloudwatchlogs-install':
          path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
          command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
          onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
          unless  => '[ -d /var/awslogs/bin ]',
          require => File['/etc/awslogs/awslogs.conf'],
          before  => Service['awslogs'],
        }
      }
      service { 'awslogs':
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/var/awslogs/etc/awslogs.conf'],
      }
    }
    default: { fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}.") }
  }

}
