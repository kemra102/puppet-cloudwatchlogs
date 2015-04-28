class cloudwatchlogs::params {

  case $::operatingsystem {
    'Amazon': { $state_file = '/var/lib/awslogs/agent-state' }
    default: { $state_file = '/var/awslogs/state/agent-state' }
  }
  $logs       = [
    { name => 'Messages', path => '/var/log/messages', },
    { name => 'Secure', path => '/var/log/secure', },
  ]

  $region                = undef
  $aws_access_key_id     = undef
  $aws_secret_access_key = undef
  $streamname            = '{instance-id}'

}
