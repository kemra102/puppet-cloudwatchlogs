# cloudwatchlogs [![Build Status](https://travis-ci.org/kemra102/puppet-cloudwatchlogs.svg)](https://travis-ci.org/kemra102/puppet-cloudwatchlogs)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with cloudwatchlogs](#setup)
    * [What cloudwatchlogs affects](#what-cloudwatchlogs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cloudwatchlogs](#beginning-with-cloudwatchlogs)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the service for the AWS Cloudwatch Logs Agent on Amazon Linux, Ubuntu, Red Hat & CentOS EC2 instances.

## Module Description

CloudWatch Logs can be used to monitor your logs for specific phrases, values, or patterns. For example, you could set an alarm on the number of errors that occur in your system logs or view graphs of web request latencies from your application logs. You can view the original log data to see the source of the problem if needed. Log data can be stored and accessed for as long as you need using highly durable, low-cost storage so you don’t have to worry about filling up hard drives.

## Setup

### What cloudwatchlogs affects

* The `awslogs` package.
* Configuration files under `/etc/awslogs`.
* The `awslogs` service.

### Setup Requirements

This module does *NOT* manage the AWS CLI credentials. As such if you are not using an IAM role (recommended) then you will need some other way of managing the credentials.

[This module](https://forge.puppetlabs.com/jdowning/awscli) by [Justin Downing](https://github.com/justindowning) is recommended for this purpose.

### Beginning with cloudwatchlogs

The minimum you need to get this module up and running is (assuming your instance is launched with a suitable IAM role):

```puppet
include '::cloudwatchlogs'
```

## Usage

The above minimal config can also be presented as:

```puppet
class { '::cloudwatchlogs': }
```

On none *Amazon Linux* instances you also need to provide a default region:

```puppet
class { '::cloudwatchlogs': region => 'eu-west-1' }
```
For each log you want sent to Cloudwatch Logs you create a `cloudwatchlogs::log` resource.

A simple example that might be used on the RedHat *::osfamily* is:

```puppet
class { '::cloudwatchlogs': region => 'eu-west-1' }

cloudwatchlogs::log { 'Messages':
  path => '/var/log/messages',
}
cloudwatchlogs::log { 'Secure':
  path => '/var/log/secure',
}
```

See the *examples/* directory for further examples.

## Reference

### `cloudwatchlogs`

#### `state_file`:

Defaults:

* Amazon Linux: `/var/lib/awslogs/agent-state`
* Other: `/var/awslogs/state/agent-state`

State file for the awslogs agent.

#### `region`:

Default: `undef`

The region your EC2 instance is running in.

**NOTE:** This is required for none *Amazon* distros.

### `cloudwatchlogs::log`

#### `path`

Default: `undef`

Optional. This is the absolute path to the log file being managed. If not set the name of the resource is used instead (and must be an absolute path if that this situation occurs).

#### `streamname`

Default: `{instance_id}`

The name of the stream in Cloudwatch Logs.

#### `datetime_format`

Default: `%b %d %H:%M:%S`

Specifies how the timestamp is extracted from logs. See [the official docs](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/AgentReference.html) for further info.

#### `log_group_name`

Default: *Resource Name*

Specifies the destination log group. A log group will be created automatically if it doesn't already exist.

#### `multi_line_start_pattern`

Default: `undef`

Optional. This is a regex string that identifies the start of a log line. See [the official docs](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/AgentReference.html) for further info.

## Http Proxy Usage

If you have a http_proxy or https_proxy then run the following puppet code after calling cloudwatchlogs to modify the launcher script as a workaround bcause awslogs python code currently doesn't have http_proxy support:

```puppet
$launcher = "#!/bin/sh
# Version: 1.3.5
echo -n $$ > /var/awslogs/state/awslogs.pid
/usr/bin/env -i AWS_CONFIG_FILE=/var/awslogs/etc/awscli.conf HOME=\$HOME HTTPS_PROXY=${http_proxy} HTTP_PROXY=${http_proxy} NO_PROXY=169.254.169.254  /bin/nice -n 4 /var/awslogs/bin/aws logs push --config-file /var/awslogs/etc/awslogs.conf >> /var/log/awslogs.log 2>&1
"

file { '/var/awslogs/bin/awslogs-agent-launcher.sh':
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0755',
  content => $launcher,
  require => Class['cloudwatchlogs'],
}
```

## Limitations

This module is currently only compatible with:

* Amazon Linux AMI 2014.09 or later.
* Ubuntu
* Red Hat
* CentOS

More information on support as well as information in general about the set-up of the Cloudwatch Logs agent can be found [here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartEC2Instance.html).

## Development

Contributions are welcome via pull requests.

## Contributors

Authors:

* [Danny Roberts](https://github.com/kemra102)
* [Russ McKendrick](https://github.com/russmckendrick/)

All other contributions: [https://github.com/kemra102/puppet-cloudwatchlogs/graphs/contributors](https://github.com/kemra102/puppet-cloudwatchlogs/graphs/contributors)
