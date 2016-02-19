require 'beaker-rspec'

# Install Puppet agent on all hosts
install_puppet_agent_on(hosts, {})

RSpec.configure do |c|
  c.formatter = :documentation
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.before :suite do
    # Install module to all hosts
    install_dev_puppet_module(:source => module_root)

    # Install dependencies
    hosts.each do |host|
      apply_manifest_on(host, 'package { "tar": }')
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
      if host.platform.match /(debian|ubuntu)/
        on(host, puppet('module', 'install', 'puppetlabs-apt'))
      end
    end
  end
end
