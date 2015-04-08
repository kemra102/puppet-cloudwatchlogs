# cloudwatchlogs

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

This module installs, configures and manages the service for the AWS Cloudwatch Logs Agent on Amazon Linux EC2 instances.

## Module Description

CloudWatch Logs can be used to monitor your logs for specific phrases, values, or patterns. For example, you could set an alarm on the number of errors that occur in your system logs or view graphs of web request latencies from your application logs. You can view the original log data to see the source of the problem if needed. Log data can be stored and accessed for as long as you need using highly durable, low-cost storage so you don’t have to worry about filling up hard drives.

## Setup

### What cloudwatchlogs affects

* The `awslogs` package.
* Configuration files under `/etc/awslogs`.
* The `awslogs` service.

### Beginning with cloudwatchlogs

The minimum you need to get this module up and running is:

```puppet
class { 'cloudwatchlogs':
  region                => 'eu-west-1',
  aws_access_key_id     => 'AKIAIOSFODNN7EXAMPLE',
  aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
}
```

## Usage

In addition to the minimum config above you can also declare which logs will be shipped to Cloudwatch Logs:

```puppet
class { 'cloudwatchlogs':
  logs                  => [
    'Messages' => '/var/log/messages',
    'Secure'   => '/var/log/secure',
    'Mail'     => '/var/log/maillog',
  ],
  region                => 'eu-west-1',
  aws_access_key_id     => 'AKIAIOSFODNN7EXAMPLE',
  aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
}
```

## Reference

### `logs`:

Default: `[ { 'Messages' => '/var/log/messages', }, { 'Secure' => '/var/log/secure', }, ]`

A hash of arrays containg the 'name' & the 'path' of the log file(s) of the log file(s) to be sent to Cloudwatch Logs.

### `region`:

Default: `undef`

The region your EC2 instance is running in.

### `aws_access_key_id`:

Default: `undef`

The Access Key ID from the IAM user that has access to Cloudwatch Logs.

### `aws_secret_access_key`:

Default: `undef`

The Secret Access Key from the IAM user that has access to Cloudwatch Logs.

## Limitations

This module is currently only compatible with:

* Amazon Linux AMI 2014.09 or later.

## Development

Contributions are welcome via pull requests.

## Contributors

Authors:

* [Danny Roberts](https://github.com/kemra102)
* [Russ McKendrick](https://github.com/russmckendrick/)

All other contributions: [https://github.com/kemra102/puppet-cloudwatchlogs/graphs/contributors](https://github.com/kemra102/puppet-cloudwatchlogs/graphs/contributors)
