class cloudwatchlogs::params {

  $logs = [
    { name => 'Messages', path => '/var/log/messages', },
    { name => 'Secure', path => '/var/log/secure', },
  ]

  $region                = undef
  $aws_access_key_id     = undef
  $aws_secret_access_key = undef

}
