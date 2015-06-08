define cloudwatchlogs::log (
  $path            = undef,
  $streamname      = '{instance_id}',
  $datetime_format = '%b %d %H:%M:%S',

){
  if $path == undef {
    $log_path = $name
  } else {
    $log_path = $path
  }

  validate_absolute_path($log_path)
  validate_string($streamname)
  validate_string($datetime_format)

  concat::fragment { "cloudwatchlogs_fragment_${name}":
    target  => '/etc/awslogs/awslogs.conf',
    content => template('cloudwatchlogs/awslogs_log.erb'),
  }

}
