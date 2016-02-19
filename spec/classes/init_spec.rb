require 'spec_helper'
describe 'stns' do

  context 'with defaults for all parameters' do
    it { should contain_class('stns') }
  end
end
