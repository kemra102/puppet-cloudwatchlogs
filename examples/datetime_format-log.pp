# Assumes Amazon Linux
include '::cloudwatchlogs'

cloudwatchlogs::log { 'Messages':
  path            => '/var/log/messages',
  datetime_format => '%a %b %d %H:%M:%S.%f',
}
cloudwatchlogs::log { 'Secure':
  path            => '/var/log/secure',
  datetime_format => '%a %b %d %H:%M:%S.%f',
}
