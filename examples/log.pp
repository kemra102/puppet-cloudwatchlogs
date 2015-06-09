# Assumes Amazon Linux
include '::cloudwatchlogs'

cloudwatchlogs::log { 'Messages':
  path => '/var/log/messages',
}
cloudwatchlogs::log { 'Secure':
  path => '/var/log/secure',
}
