require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily => 'RedHat',
  }

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
