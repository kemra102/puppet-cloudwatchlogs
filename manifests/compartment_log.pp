define cloudwatchlogs::compartment_log (
  $path            = undef,
  $streamname      = '{instance_id}',
  $datetime_format = '%b %d %H:%M:%S',
  $log_group_name  = undef,
  $multi_line_start_pattern = undef,
  $service_name    = $::cloudwatchlogs::params::service_name,
){

  if $path == undef {
    $log_path = $name
  } else {
    $log_path = $path
  }
  if $log_group_name == undef {
    $real_log_group_name = $name
  } else {
    $real_log_group_name = $log_group_name
  }

  validate_absolute_path($log_path)
  validate_string($streamname)
  validate_string($datetime_format)
  validate_string($real_log_group_name)
  validate_string($multi_line_start_pattern)

  $installed_marker = $::operatingsystem ? {
    'Amazon' => Package['awslogs'],
    default  => Exec['cloudwatchlogs-install'],
  }

  concat { "/etc/awslogs/config/${name}.conf":
    ensure         => 'present',
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    ensure_newline => true,
    warn           => true,
    require        => $installed_marker,
    notify         => Service[$service_name],
  }
  concat::fragment { "cloudwatchlogs_fragment_${name}":
    target  => "/etc/awslogs/config/${name}.conf",
    content => template('cloudwatchlogs/awslogs_log.erb'),
  }
}
