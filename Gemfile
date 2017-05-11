source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 4.7']
gem 'puppet', puppetversion

group :test, :development do
  gem 'puppetlabs_spec_helper', require: false
  gem 'puppet-lint',            require: false
  gem 'facter',                 require: false
  gem 'metadata-json-lint',     require: false
  gem 'librarian-puppet',       require: false
  gem 'xmlrpc' if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.4.0')
end

group :development do
  gem 'puppet-blacksmith', '>= 3'
end

group :system_tests do
  gem 'beaker',       require: false
  gem 'beaker-rspec', require: false
  gem 'toml-rb',      require: false
end
