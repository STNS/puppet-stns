require 'spec_helper_acceptance'

describe 'stns::client class' do
  let(:manifest) do
    <<-EOS
      package { 'openssh-server':
        ensure => installed,
      }

      $ssh_service = $facts['osfamily'] ? {
        'RedHat' => 'sshd',
        'Debian' => 'ssh',
      }

      service { $ssh_service:
        ensure => running,
      }

      class { '::stns::client':
        api_end_point      => 'http://stns.example.jp:1104',
        auth_token         => 'xxxxexamplxxxxx',
        user               => 'sample',
        password           => 's@mp1e',
        wrapper_path       => '/usr/local/bin/stns-query-wrapper',
        chain_ssh_wrapper  => '/usr/libexec/openssh/ssh-ldap-wrapper',
        ssl_verify         => true,
        request_timeout    => 3,
        request_retry      => 1,
        http_proxy         => 'http://proxy.example.com:1104',
        uid_shift          => 0,
        gid_shift          => 0,
        cache              => true,
        cache_dir          => '/var/cache/stns',
        cache_ttl          => 600,
        negative_cache_ttl => 60,
        libnss_stns_ensure => latest,
        handle_nsswitch    => true,
        handle_sshd_config => true,
        cached_enable      => true,
        cached_prefetch    => true,
      }
    EOS
  end

  it 'works without errors' do
    result = apply_manifest(manifest, catch_failures: true)
    expect(result.exit_code).to eq 2
  end

  it 'runs a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe package('libnss-stns-v2') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/stns/client/stns.conf') do
    its(:content) { is_expected.to match %r{^api_endpoint = "http://stns.example.jp:1104"$} }
    its(:content) { is_expected.to match %r{^auth_token = "xxxxexamplxxxxx"$} }
    its(:content) { is_expected.to match %r{^user = "sample"$} }
    its(:content) { is_expected.to match %r{^password = "s@mp1e"$} }
    its(:content) { is_expected.to match %r{^chain_ssh_wrapper = "/usr/libexec/openssh/ssh-ldap-wrapper"$} }
    its(:content) { is_expected.to match %r{^wrapper_path = "/usr/local/bin/stns-query-wrapper"$} }
    its(:content) { is_expected.to match %r{^ssl_verify = true$} }
    its(:content) { is_expected.to match %r{^http_proxy = "http://proxy.example.com:1104"$} }
    its(:content) { is_expected.to match %r{^uid_shift = 0$} }
    its(:content) { is_expected.to match %r{^gid_shift = 0$} }
    its(:content) { is_expected.to match %r{^request_timeout = 3$} }
    its(:content) { is_expected.to match %r{^request_retry = 1$} }
    its(:content) { is_expected.to match %r{^cache = true$} }
    its(:content) { is_expected.to match %r{^cache_dir = "/var/cache/stns"$} }
    its(:content) { is_expected.to match %r{^cache_ttl = 600$} }
    its(:content) { is_expected.to match %r{^negative_cache_ttl = 60$} }
    its(:content) { is_expected.to match %r{\n\[cached\]\nenable = true\nprefetch = true\n}m }
  end

  describe file('/etc/nsswitch.conf') do
    its(:content) { is_expected.to match %r{^\s*passwd:\s+files\s+stns} }
    its(:content) { is_expected.to match %r{^\s*shadow:\s+files\s+stns} }
    its(:content) { is_expected.to match %r{^\s*group:\s+files\s+stns} }
  end

  describe file('/etc/ssh/sshd_config') do
    its(:content) { is_expected.to match %r{^\s*PubkeyAuthentication\s+yes$} }
    its(:content) { is_expected.to match %r{^\s*AuthorizedKeysCommand\s+/usr/lib/stns/stns-key-wrapper$} }
    its(:content) { is_expected.to match %r{^\s*AuthorizedKeysCommand(User|RunAs)\s+root$} }
  end
end
