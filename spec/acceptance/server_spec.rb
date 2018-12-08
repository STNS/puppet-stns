require 'spec_helper_acceptance'

describe 'stns::server class' do
  let(:manifest) do
    <<-EOS
      class { '::stns::server':
        port     => 1104,
        user     => 'sample',
        password => 's@mp1e',
      }

      ::stns::server::users { 'sandbox':
        id         => 1001,
        group_id   => 1001,
        keys       => 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH3Mk+/KUhwDvZ7tthykjzU4KHNWPb9F8CLK6agvVxNijfG51Yg8mBsPqafCqHdFB15M1CisDK7iyTGhcwvHNDA= sample@local',
        link_users => 'foo',
      }

      ::stns::server::groups { 'sandbox':
        id    => 1001,
        users => 'sandbox',
      }
    EOS
  end

  it 'works without errors' do
    result = apply_manifest(manifest, acceptable_exit_codes: [0, 2], catch_failures: true)
    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it 'runs a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe package('stns-v2') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/stns/conf.d') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/stns/server/stns.conf') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{^port\s+=\s+1104$} }
    its(:content) { is_expected.to match %r{^user\s+=\s+"sample"$} }
    its(:content) { is_expected.to match %r{^password\s+=\s+"s@mp1e"$} }

    its(:content) { is_expected.to match %r{^\[users.sandbox\]\nid = 1001$} }
    its(:content) { is_expected.to match %r{^group_id = 1001$} }
    its(:content) { is_expected.to match %r{^directory = "/home/sandbox"$} }
    its(:content) { is_expected.to match %r{^shell = "/bin/bash"$} }
    its(:content) { is_expected.to match %r{^keys = \[".+"\]$} }
    its(:content) { is_expected.to match %r{^link_users = \["foo"\]$} }

    its(:content) { is_expected.to match %r{^\[groups.sandbox\]\nid = 1001$} }
    its(:content) { is_expected.to match %r{^users = \["sandbox"\]$} }
  end

  describe service('stns') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
