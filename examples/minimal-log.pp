# Assumes Amazon Linux
include '::cloudwatchlogs'

cloudwatchlogs::log { '/var/log/messages': }
cloudwatchlogs::log { '/var/log/secure': }
