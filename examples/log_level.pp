# Log Level according to: (https://docs.python.org/2/library/logging.config.html#logging-config-fileformat)
#INFO
#WARNING

class { '::cloudwatchlogs': 
	region => 'eu-west-1',
	log_level => 'INFO' 
}

cloudwatchlogs::log { 'Messages':
  path => '/var/log/messages',
}
cloudwatchlogs::log { 'Secure':
  path => '/var/log/secure',
}