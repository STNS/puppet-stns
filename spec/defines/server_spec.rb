require 'spec_helper'
describe 'stns::server::users' do
  let(:title) { 'sample' }

  let(:params) do
    {
      id:         1001,
      group_id:   1001,
      directory:  '/home/sample',
      shell:      '/bin/bash',
      keys:       'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH3Mk+/KUhwDvZ7tthykjzU4KHNWPb9F8CLK6agvVxNijfG51Yg8mBsPqafCqHdFB15M1CisDK7iyTGhcwvHNDA= sample@local',
      link_users: 'sample',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_stns__server__users('sample') }
  end
end

describe 'stns::server::groups' do
  let(:title) { 'sample' }

  let(:params) do
    {
      id:    1001,
      users: 'sample',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_stns__server__groups('sample') }
  end
end
