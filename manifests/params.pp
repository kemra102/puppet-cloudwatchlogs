class cloudwatchlogs::params {

  case $::operatingsystem {
    'Amazon': { $state_file = '/var/lib/awslogs/agent-state' }
    default: { $state_file = '/var/awslogs/state/agent-state' }
  }
  $logs       = [
    { 'Messages' => '/var/log/messages', },
    { 'Secure'   => '/var/log/secure', },
  ]
  
  $datetime_formats       = [
    { 'Messages' => '%b %d %H:%M:%S', },
    { 'Secure'   => '%b %d %H:%M:%S', },
  ]
  
  $region                = undef
  $aws_access_key_id     = undef
  $aws_secret_access_key = undef
  $streamname            = '{instance_id}'

}
