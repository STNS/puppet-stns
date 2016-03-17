require 'spec_helper_acceptance'

describe 'stns::client class' do
  let(:manifest) {
    <<-EOS
      package { 'openssh-server':
        ensure => installed,
      }

      service { 'sshd':
        ensure => running,
      }

      class { '::stns::client':
        api_end_point      => [
          'http://stns1.example.jp:1104',
          'http://stns2.example.jp:1104',
        ],
        user               => 'sample',
        password           => 's@mp1e',
        wrapper_path       => '/usr/local/bin/stns-query-wrapper',
        chain_ssh_wrapper  => '/usr/libexec/openssh/ssh-ldap-wrapper',
        ssl_verify         => true,
        handle_nsswitch    => true,
        handle_sshd_config => true,
      }
    EOS
  }

  it "should work without errors" do
    result = apply_manifest(manifest, :acceptable_exit_codes => [0, 2], :catch_failures => true)
    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it "should run a second time without changes" do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe package('libnss-stns') do
    it { should be_installed }
  end

  describe file('/etc/stns/libnss_stns.conf') do
    it { should be_file }
    its(:content) { should match %r|^api_end_point = \["http://stns1.example.jp:1104", "http://stns2.example.jp:1104"\]$| }
    its(:content) { should match /^user = "sample"$/ }
    its(:content) { should match /^password = "s@mp1e"$/ }
    its(:content) { should match %r|^wrapper_path = "/usr/local/bin/stns-query-wrapper"$| }
    its(:content) { should match %r|^chain_ssh_wrapper = "/usr/libexec/openssh/ssh-ldap-wrapper"$| }
    its(:content) { should match /^ssl_verify = true$/ }
  end

  describe file('/etc/nsswitch.conf') do
    its(:content) { should match /^\s*passwd:\s+files\s+stns/ }
    its(:content) { should match /^\s*shadow:\s+files\s+stns/ }
    its(:content) { should match /^\s*group:\s+files\s+stns/ }
  end

  describe file('/etc/ssh/sshd_config') do
    its(:content) { should match /^\s*PubkeyAuthentication\s+yes$/ }
    its(:content) { should match %r|^\s*AuthorizedKeysCommand\s+/usr/local/bin/stns-key-wrapper$| }
    its(:content) { should match /^\s*AuthorizedKeysCommand(User|RunAs)\s+root$/ }
  end
end
