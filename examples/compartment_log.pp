# Assumes Amazon Linux
#See here for more info about compartmentalization: (http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/AgentReference.html#d0e24912)
include '::cloudwatchlogs'

cloudwatchlogs::compartment_log { 'AccessLogs':
  path => '/var/log/httpd/access_log',
}
cloudwatchlogs::compartment_log { 'ErrorLogs':
  path => '/var/log/httpd/error_log',
}