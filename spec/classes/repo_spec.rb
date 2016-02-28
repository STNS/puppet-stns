require 'spec_helper'
describe 'stns::repo' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::repo') }
  end
end
