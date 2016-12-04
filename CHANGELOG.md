## 2016-12-04 - Release 3.2.1
### Summary
Small bugfix release.

#### Bugfixes
- Force creation of symlink at `/var/awslogs/etc/conf` to prevent issues during upgrades.
- Add appropriate `requires` based on OS for the main config.

## 2016-07-12 - Release 2.3.0
### Summary
Large feature and bug fix release.

#### Bugfixes
- Ensure config is concated before installation.
- Various linting & test fixes.

#### Features
- Support for setting `cloudwatchlogs::logs` via a Hiera hash.
- Support setting the `region` in the main `awscli` config file.
- Support for setting the `log_level` for logs.
- Add support for `cloudwatchlogs::compartment_log`.

## 2016-03-22 - Release 2.2.0
### Summary
Support additional CloudWatch Logs functionality & small bigfixes.

#### Bugfixes
- Ensure `wget` is installed.

#### Features
- Now supports the `multi_line_start_pattern` for each log.
- Logs can now be defined as a hash as a part fo the main class.

## 2015-09-15 - Release 2.1.0
### Summary
Now able to additionally set an additional config line for logs.

#### Features
- You can now specify the `log_group_name` explicitly, otherwise it defaults to the resource name as per the previous behaviour.

## 2015-06-09 - Release 2.0.0
### Summary
Major release switching to using [puppetlabs/concat](https://forge.puppet.com/puppetlabs/concat) to build config files and various other breaking changes.

#### Features
- Moved to using [puppetlabs/concat](https://forge.puppet.com/puppetlabs/concat) for each log file entry. This allows use of more customizable entries more easily down the road.
- Removed management of AWS CLI keys, this should be done by mdoules designed for this purpose.
- Documented usage of using a http_proxy on instances that might require it.
- Provided examples of IAM role for Cloudwatch Logs & of various ways to specify log entries.

## 2015-06-04 - Release 1.1.2
### Summary
Small bugfix release.

#### Bugfixes
- Fixed default stream name.
- Only install `wget` package if not defined else where in catalogue.

## 2015-05-26 - Release 1.1.1
### Summary
Minor bugfix release.

#### Bugfixes
- Fix metadata requirement for [puppetlabs/stdlib](https://forge.puppet.com/puppetlabs/stdlib).
- Fix `streamname` variable format.

## 2015-04-30 - Release 1.1.0
### Summary
Small feature release supporting slightly more fine grained log config.

#### Features
- Make credentials optional, creating only if info is provided. Otherwise, assume an IAM role is present to use.
- Add `streamname` variable.

## 2015-04-18 - Release 1.0.0
### Summary
Initial release.
