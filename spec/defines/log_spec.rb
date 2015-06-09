require 'spec_helper'
describe 'cloudwatchlogs::log', :type => :define do
  context 'standard log entry' do
    let (:title) { 'Messages' }
    let (:params) {{
      :path => '/var/log/messages',
    }}
    it {
      should contain_concat_fragment('cloudwatchlogs_fragment_Messages').with_target('/etc/awslogs/awslogs.conf')
    }
  end
end
