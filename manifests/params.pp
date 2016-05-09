class cloudwatchlogs::params {

  case $::operatingsystem {
    'Amazon': { $state_file = '/var/lib/awslogs/agent-state' }
    default: { $state_file = '/var/awslogs/state/agent-state' }
  }
  $logging_config_file = '/etc/awslogs/awslogs_dot_log.conf'
  $region = undef
  $log_level = undef
}
