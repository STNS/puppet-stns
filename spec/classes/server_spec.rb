require 'spec_helper'
describe 'stns::server' do
  context 'with defaults for all parameters' do
    let(:params) do
      {
        'port' => 1104,
        'user' => :undef,
        'password' => :undef,
        'tokens' => :undef,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::server') }
  end
end
