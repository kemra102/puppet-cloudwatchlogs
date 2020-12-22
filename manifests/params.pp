class cloudwatchlogs::params {

  case $::operatingsystem {
    'Amazon': { $state_file = '/var/lib/awslogs/agent-state' }
    default: { $state_file = '/var/awslogs/state/agent-state' }
  }
  $osname = $facts['os']['name']
  $osmajor = $facts['os']['release']['major']
  $oslong = "${osname}${osmajor}"

  case $oslong {
    'Amazon2': { $service_name = 'awslogsd' }
    'Amazon4': { $service_name = 'awslogsd' } #Amazon Linux 2 returns 4 for osmajor
    default: { $service_name = 'awslogs' }
  }
  $logging_config_file = '/etc/awslogs/awslogs_dot_log.conf'
  $region = undef
  $log_level = undef
}
