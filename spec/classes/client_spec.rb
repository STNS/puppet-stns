require 'spec_helper'
describe 'stns::client' do
  context 'with defaults for all parameters' do
    let(:params) do
      {
        'api_end_point' => :undef,
        'auth_token' => :undef,
        'user' => :undef,
        'password' => :undef,
        'wrapper_path' => :undef,
        'chain_ssh_wrapper' => :undef,
        'ssl_verify' => :undef,
        'request_timeout' => :undef,
        'request_retry' => :undef,
        'http_proxy' => :undef,
        'uid_shift' => :undef,
        'gid_shift' => :undef,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::client') }
  end
end
