require 'spec_helper'
describe 'stns::server' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::server') }
  end
end

describe 'stns::server::users' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::server::users') }
  end
end

describe 'stns::server::groups' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('stns::server::groups') }
  end
end
