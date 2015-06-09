# Assumes Amazon Linux
include '::cloudwatchlogs'

cloudwatchlogs::log { 'Messages':
  path       => '/var/log/messages',
  streamname => 'web-servers',
}
cloudwatchlogs::log { 'Secure':
  path 	     => '/var/log/secure',
  streamname => 'web-servers',
}
