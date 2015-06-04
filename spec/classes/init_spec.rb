require 'spec_helper'
describe 'cloudwatchlogs', :type => :class do
  context 'default parameters on Amazon Linux' do
    let (:facts) {{
      :operatingsystem => 'Amazon',
    }}
    it {
      should create_class('cloudwatchlogs')
      should contain_package('awslogs').with_ensure('present')
      should contain_file('/etc/awslogs/awslogs.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      should contain_file('/etc/awslogs/awslogs.conf').with_content(/state_file = \/var\/lib\/awslogs\/agent-stat/)
      should contain_service('awslogs').with({
        'ensure'     => 'running',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'true',
      })
    }
  end
  context 'set aws region & keys' do
    let (:params) {{
      :region                => 'eu-west-1',
      :aws_access_key_id     => 'AKIAIOSFODNN7EXAMPLE',
      :aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
    }}
    let (:facts) {{
      :operatingsystem => 'Amazon',
    }}
    it {
      should contain_file('/etc/awslogs/awscli.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }
  end
  context 'only region on Ubuntu' do
    let (:params) {{
      :region => 'eu-west-1',
    }}
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
    }}
    it {
      should contain_package('wget').with_ensure('present')
      should contain_exec('cloudwatchlogs-wget').with({
        'path'    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        'command' => 'wget -O /usr/local/src/awslogs-agent-setup.py https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py',
        'unless'  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
      })
      should contain_file('/etc/awslogs').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/awslogs').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/awslogs/etc').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/etc/awslogs/awslogs.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      should contain_file('/etc/awslogs/awslogs.conf').with_content(/state_file = \/var\/awslogs\/state\/agent-stat/)
      should contain_file('/var/awslogs/etc/awslogs.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      should contain_exec('cloudwatchlogs-install').with({
        'path'    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        'command' => 'python /usr/local/src/awslogs-agent-setup.py -n -r eu-west-1 -c /etc/awslogs/awslogs.conf',
        'onlyif'  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
        'unless'  => '[ -d /var/awslogs/bin ]',
      })
    }
  end
end
