require 'spec_helper'
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
