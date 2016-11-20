require 'spec_helper_acceptance'
require 'toml'

describe 'stns::client class' do
  let(:manifest) do
    <<-EOS
      package { 'openssh-server':
        ensure => installed,
      }

      $ssh_service = $::osfamily ? {
        'RedHat' => 'sshd',
        'Debian' => 'ssh',
      }

      service { $ssh_service:
        ensure => running,
      }

      class { '::stns::client':
        api_end_point      => [
          'http://stns1.example.jp:1104',
          'http://stns2.example.jp:1104',
        ],
        user               => 'sample',
        password           => 's@mp1e',
        wrapper_path       => '/usr/lib/stns/stns-query-wrapper',
        chain_ssh_wrapper  => '/usr/libexec/openssh/ssh-ldap-wrapper',
        ssl_verify         => true,
        request_timeout    => 3,
        http_proxy         => 'http://proxy.example.com:1104',
        uid_shift          => 0,
        gid_shift          => 0,
        request_header     => {
          'x-api-key1' => 'foo',
          'x-api-key2' => 'bar',
        },
        libnss_stns_ensure => latest,
        libpam_stns_ensure => latest,
        handle_nsswitch    => true,
        handle_sshd_config => true,
      }
    EOS
  end

  it 'should work without errors' do
    result = apply_manifest(manifest, catch_failures: true)
    expect(result.exit_code).to eq 2
  end

  it 'should run a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  %w(
    libnss-stns
    libpam-stns
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe file('/etc/stns/libnss_stns.conf') do
    it { should be_file }

    it "configures" do
      conf = TOML.parse(subject.content)

      expect(conf['api_end_point']).to include 'http://stns1.example.jp:1104'
      expect(conf['api_end_point']).to include 'http://stns2.example.jp:1104'
      expect(conf['user']).to eq 'sample'
      expect(conf['password']).to eq 's@mp1e'
      expect(conf['wrapper_path']).to eq '/usr/lib/stns/stns-query-wrapper'
      expect(conf['chain_ssh_wrapper']).to eq '/usr/libexec/openssh/ssh-ldap-wrapper'
      expect(conf['ssl_verify']).to eq true
      expect(conf['request_timeout']).to eq 3
      expect(conf['http_proxy']).to eq 'http://proxy.example.com:1104'
      expect(conf['uid_shift']).to eq 0
      expect(conf['gid_shift']).to eq 0
      expect(conf['request_header']['x-api-key1']).to eq 'foo'
      expect(conf['request_header']['x-api-key2']).to eq 'bar'
    end
  end

  describe file('/etc/nsswitch.conf') do
    its(:content) { should match /^\s*passwd:\s+files\s+stns/ }
    its(:content) { should match /^\s*shadow:\s+files\s+stns/ }
    its(:content) { should match /^\s*group:\s+files\s+stns/ }
  end

  describe file('/etc/ssh/sshd_config') do
    its(:content) { should match /^\s*PubkeyAuthentication\s+yes$/ }
    its(:content) { should match %r{^\s*AuthorizedKeysCommand\s+/usr/lib/stns/stns-key-wrapper$} }
    its(:content) { should match /^\s*AuthorizedKeysCommand(User|RunAs)\s+root$/ }
  end
end
